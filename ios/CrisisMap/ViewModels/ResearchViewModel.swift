import Foundation
import SwiftData

@MainActor
@Observable
final class ResearchViewModel {
    var articles: [ThinkTankArticle] = []
    var isLoading = false
    var error: String?
    var isOffline = false

    var selectedRegion: Region = .all

    private var modelContext: ModelContext?
    private var topicCatalog: [String] = []

    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }

    // MARK: - Computed Properties

    /// Regions with article counts
    var regionsWithCounts: [(region: Region, count: Int)] {
        Region.allCases.map { region in
            let count = region == .all
                ? articles.count
                : articles.filter { region.matchesArticle($0) }.count
            return (region, count)
        }
    }

    /// Topics available for a given region, with counts, sorted by count descending
    func topicsForRegion(_ region: Region) -> [(topic: String, count: Int)] {
        let regionArticles = articles.filter { region.matchesArticle($0) }
        var topicCounts: [String: Int] = [:]
        for article in regionArticles {
            for topic in article.topics {
                topicCounts[topic, default: 0] += 1
            }
        }

        if topicCatalog.isEmpty {
            return topicCounts
                .map { (topic: $0.key, count: $0.value) }
                .sorted { $0.count > $1.count }
        }

        let orderByTopic = Dictionary(uniqueKeysWithValues: topicCatalog.enumerated().map { ($1, $0) })
        return topicCounts
            .compactMap { topic, count in
                guard count > 0, orderByTopic[topic] != nil else { return nil }
                return (topic: topic, count: count)
            }
            .sorted { lhs, rhs in
                if lhs.count == rhs.count {
                    return (orderByTopic[lhs.topic] ?? Int.max) < (orderByTopic[rhs.topic] ?? Int.max)
                }
                return lhs.count > rhs.count
            }
    }

    /// Articles filtered by region and optional topic, sorted by date descending
    func articlesFor(region: Region, topic: String?) -> [ThinkTankArticle] {
        articles
            .filter { region.matchesArticle($0) }
            .filter { article in
                guard let topic else { return true }
                return article.topics.contains(topic)
            }
            .sorted { $0.date > $1.date }
    }

    // MARK: - Data Loading

    func loadData() async {
        isLoading = true
        isOffline = false
        error = nil

        do {
            let weekIndex = try await APIClient.shared.fetchWeekIndex()
            let newArticles = try await fetchWithCache(weekIndex: weekIndex)
            articles = newArticles
            let topicIndex = try? await APIClient.shared.fetchTopicsIndex()
            applyTopicCatalog(topicIndex?.topics ?? [])

            if newArticles.isEmpty {
                error = String(localized: "research.empty")
            }
        } catch {
            self.error = error.localizedDescription
            applyTopicCatalog([])
            // Fallback to cache
            let cached = loadFromCache()
            if !cached.isEmpty {
                articles = cached
                isOffline = true
                self.error = nil
            }
        }

        isLoading = false
    }

    func applyTopicCatalog(_ topics: [String]) {
        var seen = Set<String>()
        topicCatalog = topics
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .filter { seen.insert($0.lowercased()).inserted }
    }

    // MARK: - Cache Logic

    private func fetchWithCache(weekIndex: WeekIndex) async throws -> [ThinkTankArticle] {
        guard let modelContext else {
            return try await fetchAllWeeks(weekIndex.weeks)
        }

        var allArticles: [ThinkTankArticle] = []
        let decoder = JSONDecoder()

        // Fetch cached weeks
        let descriptor = FetchDescriptor<CachedWeekly>()
        let cachedWeeks = (try? modelContext.fetch(descriptor)) ?? []
        let cachedByWeek = Dictionary(uniqueKeysWithValues: cachedWeeks.map { ($0.week, $0) })

        // Determine which weeks need fetching
        var weeksToFetch: [WeekEntry] = []

        for entry in weekIndex.weeks {
            if let cached = cachedByWeek[entry.week], cached.uploadedAt == entry.uploaded {
                // Use cache
                if let weekly = try? decoder.decode(ThinkTankWeekly.self, from: cached.json) {
                    allArticles.append(contentsOf: weekly.articles)
                }
            } else {
                weeksToFetch.append(entry)
            }
        }

        // Fetch new/updated weeks in parallel
        let encoder = JSONEncoder()
        var failedWeeks: [String] = []

        await withTaskGroup(of: (WeekEntry, ThinkTankWeekly?, String?).self) { group in
            for entry in weeksToFetch {
                group.addTask {
                    do {
                        let weekly = try await APIClient.shared.fetchWeekly(week: entry.week)
                        return (entry, weekly, nil)
                    } catch {
                        return (entry, nil, error.localizedDescription)
                    }
                }
            }

            for await result in group {
                let (entry, weekly, errorText) = result
                guard let weekly else {
                    failedWeeks.append("\(entry.week): \(errorText ?? "unknown error")")
                    continue
                }

                allArticles.append(contentsOf: weekly.articles)

                // Save to cache
                if let jsonData = try? encoder.encode(weekly) {
                    if let existing = cachedByWeek[entry.week] {
                        existing.json = jsonData
                        existing.uploadedAt = entry.uploaded
                        existing.fetchedAt = .now
                    } else {
                        let cached = CachedWeekly(week: entry.week, json: jsonData, uploadedAt: entry.uploaded)
                        modelContext.insert(cached)
                    }
                }
            }
        }

        try? modelContext.save()

        if allArticles.isEmpty && !weeksToFetch.isEmpty {
            throw ResearchDataError.allWeeksFailed(failedWeeks)
        }

        return allArticles
    }

    private func fetchAllWeeks(_ entries: [WeekEntry]) async throws -> [ThinkTankArticle] {
        var allArticles: [ThinkTankArticle] = []
        var failedWeeks: [String] = []

        await withTaskGroup(of: (WeekEntry, [ThinkTankArticle]?, String?).self) { group in
            for entry in entries {
                group.addTask {
                    do {
                        let articles = try await APIClient.shared.fetchWeekly(week: entry.week).articles
                        return (entry, articles, nil)
                    } catch {
                        return (entry, nil, error.localizedDescription)
                    }
                }
            }

            for await result in group {
                let (entry, articles, errorText) = result
                if let articles {
                    allArticles.append(contentsOf: articles)
                } else {
                    failedWeeks.append("\(entry.week): \(errorText ?? "unknown error")")
                }
            }
        }

        if allArticles.isEmpty && !entries.isEmpty {
            throw ResearchDataError.allWeeksFailed(failedWeeks)
        }

        return allArticles
    }

    private func loadFromCache() -> [ThinkTankArticle] {
        guard let modelContext else { return [] }
        let descriptor = FetchDescriptor<CachedWeekly>()
        let decoder = JSONDecoder()
        guard let cachedWeeks = try? modelContext.fetch(descriptor) else { return [] }
        return cachedWeeks.compactMap { cached in
            try? decoder.decode(ThinkTankWeekly.self, from: cached.json).articles
        }.flatMap { $0 }
    }
}

enum ResearchDataError: LocalizedError {
    case allWeeksFailed([String])

    var errorDescription: String? {
        switch self {
        case .allWeeksFailed(let details):
            if details.isEmpty {
                return "Failed to load research data from all weeks."
            }
            let sample = details.prefix(3).joined(separator: " | ")
            return "Failed to load research data from all weeks. \(sample)"
        }
    }
}
