import Foundation
import SwiftData

struct NewsClusterSummary: Identifiable, Sendable {
    let clusterId: String
    let label: String
    let score: Double
    let sourceCount: Int
    let lastMentionAt: Date?
    let regions: [Region]
    let topics: [String]
    let sources: [String]
    let events: [CrisisEvent]

    var id: String { clusterId }

    var attributionSummary: String? {
        let directCount = events.filter { $0.newsSource?.attribution == .direct }.count
        let derivedCount = events.filter { $0.newsSource?.attribution == .derived }.count

        var parts: [String] = []
        if directCount > 0 {
            parts.append("\(directCount) direct")
        }
        if derivedCount > 0 {
            parts.append("\(derivedCount) derived")
        }

        return parts.isEmpty ? nil : parts.joined(separator: " · ")
    }

    var sourceKindSummary: String? {
        let orderedKinds: [NewsSourceKind] = [.wire, .publisher, .social, .aggregator]
        let labelsByKind: [NewsSourceKind: String] = [
            .wire: "wire",
            .publisher: "publisher",
            .social: "social",
            .aggregator: "aggregator"
        ]

        let presentKinds = Set(events.compactMap { $0.newsSource?.kind })
        let labels = orderedKinds.compactMap { kind in
            presentKinds.contains(kind) ? labelsByKind[kind] : nil
        }

        return labels.isEmpty ? nil : labels.joined(separator: " · ")
    }

    var rowSourceSummary: String? {
        let attributionKinds = Set(events.compactMap { $0.newsSource?.attribution })
        if attributionKinds.count > 1 {
            return attributionSummary
        }

        return sourceKindSummary ?? attributionSummary
    }

    var detailAttributionSummary: String? {
        let attributionKinds = Set(events.compactMap { $0.newsSource?.attribution })
        guard attributionKinds.count > 1 else {
            return nil
        }

        return attributionSummary
    }
}

protocol NewsEventProviding: Sendable {
    func fetchEvents(limit: Int) async throws -> [CrisisEvent]
}

@MainActor
protocol NewsBatchCaching {
    func save(events: [CrisisEvent], fetchedAt: Date) throws
    func load() throws -> (events: [CrisisEvent], fetchedAt: Date)?
}

struct EmptyNewsEventProvider: NewsEventProviding {
    func fetchEvents(limit: Int) async throws -> [CrisisEvent] {
        []
    }
}

struct FallbackNewsEventProvider: NewsEventProviding {
    let primary: any NewsEventProviding
    let fallback: any NewsEventProviding

    static func newsTabDefault() -> FallbackNewsEventProvider {
        FallbackNewsEventProvider(
            primary: NewsSourceAggregator.newsTabDefault(),
            fallback: NewsSourceAggregator.builtInFallback()
        )
    }

    func fetchEvents(limit: Int) async throws -> [CrisisEvent] {
        let primaryEvents: [CrisisEvent]
        do {
            primaryEvents = try await primary.fetchEvents(limit: limit)
        } catch {
            primaryEvents = []
        }

        guard primaryEvents.isEmpty else {
            return primaryEvents
        }

        return try await fallback.fetchEvents(limit: limit)
    }
}

@MainActor
@Observable
final class NewsViewModel {
    var allClusters: [NewsClusterSummary] = []
    var isLoading = false
    var isOffline = false
    var error: String?

    var selectedRegion: Region = .all
    var selectedTopic: String?
    var searchText: String = ""

    var availableTopics: [String] = []

    private var scoringConfig: NewsScoringConfig
    private var didLoadScoringConfig = false
    private var rules: [NewsClusterRule] = []
    private var mentionStore: MentionStore?
    private var scheduler: NewsPrecomputeScheduler?
    private let eventProvider: any NewsEventProviding
    private var batchCache: (any NewsBatchCaching)?
    private let usesInjectedBatchCache: Bool
    private let eventLimit: Int

    init(
        eventProvider: any NewsEventProviding = FallbackNewsEventProvider.newsTabDefault(),
        batchCache: (any NewsBatchCaching)? = nil,
        eventLimit: Int = 100,
        scoringConfig: NewsScoringConfig = .default
    ) {
        self.eventProvider = eventProvider
        self.batchCache = batchCache
        self.usesInjectedBatchCache = batchCache != nil
        self.eventLimit = max(1, eventLimit)
        self.scoringConfig = scoringConfig
    }

    func setModelContext(_ modelContext: ModelContext) {
        mentionStore = MentionStore(modelContext: modelContext)
        scheduler = NewsPrecomputeScheduler(modelContext: modelContext)
        if !usesInjectedBatchCache {
            batchCache = NewsBatchCache(modelContext: modelContext)
        }
    }

    var filteredClusters: [NewsClusterSummary] {
        allClusters.filter { cluster in
            if selectedRegion != .all && !cluster.regions.contains(selectedRegion) {
                return false
            }

            if let selectedTopic, !cluster.topics.contains(selectedTopic) {
                return false
            }

            if !searchText.isEmpty {
                let q = searchText.lowercased()
                let haystack = [
                    cluster.label,
                    cluster.topics.joined(separator: " "),
                    cluster.sources.joined(separator: " "),
                    cluster.events.map(\.title).joined(separator: " ")
                ]
                .joined(separator: " ")
                .lowercased()

                if !haystack.contains(q) {
                    return false
                }
            }

            return true
        }
    }

    func refresh(now: Date = .now) async {
        isLoading = true
        defer { isLoading = false }

        do {
            loadScoringConfigIfNeeded()
            let liveEvents = try await eventProvider.fetchEvents(limit: eventLimit)
            saveLiveBatchIfPossible(events: liveEvents, fetchedAt: now)
            try rebuildClusters(from: liveEvents, now: now)
            isOffline = false
            error = nil
        } catch {
            let liveError = error
            do {
                if let cachedBatch = try batchCache?.load() {
                    try rebuildClusters(from: cachedBatch.events, now: now)
                    isOffline = true
                    self.error = nil
                } else {
                    clearClusters()
                    self.error = liveError.localizedDescription
                }
            } catch {
                clearClusters()
                self.error = liveError.localizedDescription
            }
        }
    }

    private func rebuildClusters(from events: [CrisisEvent], now: Date) throws {
        let activeRules = try loadRules()
        let engine = NewsClusteringEngine(rules: activeRules)
        let clustered = engine.cluster(events: events)
        let mentions = try resolveMentions(from: clustered)
        let calculator = MentionIndexCalculator(config: scoringConfig)
        let scores = calculator.calculate(mentions: mentions, rules: activeRules, asOf: now)

        apply(scores: scores, clusteredEvents: clustered)
        try persistNextSnapshot(scores: scores, now: now)
    }

    private func saveLiveBatchIfPossible(events: [CrisisEvent], fetchedAt: Date) {
        do {
            try batchCache?.save(events: events, fetchedAt: fetchedAt)
        } catch {
            // Cache persistence is best-effort; fresh results should still render.
        }
    }

    private func clearClusters() {
        allClusters = []
        availableTopics = []
        isOffline = false
        error = nil
    }

    func apply(scores: [MentionClusterScore], clusteredEvents: [ClusteredEvent]) {
        let eventsByCluster = Dictionary(grouping: clusteredEvents, by: \.clusterId)

        allClusters = scores.map { score in
            let events = (eventsByCluster[score.clusterId] ?? [])
                .map(\.event)
                .sorted { $0.date > $1.date }

            let sources = Array(Set(events.map(\.source))).sorted()

            return NewsClusterSummary(
                clusterId: score.clusterId,
                label: score.label,
                score: score.score,
                sourceCount: score.sourceCount,
                lastMentionAt: score.lastMentionAt,
                regions: score.regions,
                topics: score.topics,
                sources: sources,
                events: events
            )
        }
        .sorted {
            if $0.score == $1.score {
                return $0.clusterId < $1.clusterId
            }
            return $0.score > $1.score
        }

        availableTopics = Array(Set(allClusters.flatMap(\.topics))).sorted()

        if let selectedTopic, !availableTopics.contains(selectedTopic) {
            self.selectedTopic = nil
        }
    }

    private func loadScoringConfigIfNeeded() {
        guard !didLoadScoringConfig else { return }
        didLoadScoringConfig = true

        if let loaded = try? NewsScoringConfigLoader.load() {
            scoringConfig = loaded
        }
    }

    private func loadRules() throws -> [NewsClusterRule] {
        if !rules.isEmpty {
            return rules
        }

        rules = try NewsClusterRuleLoader.load()
        return rules
    }

    private func resolveMentions(from clusteredEvents: [ClusteredEvent]) throws -> [CachedMention] {
        if let mentionStore {
            try mentionStore.ingest(clusteredEvents: clusteredEvents)
            return try mentionStore.fetchAll()
        }

        return dedupMentions(from: clusteredEvents)
    }

    private func dedupMentions(from clusteredEvents: [ClusteredEvent]) -> [CachedMention] {
        let grouped = Dictionary(grouping: clusteredEvents) { event in
            MentionStore.makeKey(source: MentionStore.identity(for: event.event), clusterId: event.clusterId)
        }

        return grouped.compactMap { key, group in
            guard
                let first = group.map({ $0.event.date }).min(),
                let last = group.map({ $0.event.date }).max(),
                let sample = group.max(by: { $0.event.date < $1.event.date })
            else {
                return nil
            }

            return CachedMention(
                key: key,
                source: MentionStore.identity(for: sample.event),
                clusterId: sample.clusterId,
                firstSeenAt: first,
                lastSeenAt: last,
                sampleEventId: sample.event.id,
                sourceAttribution: sample.event.newsSource?.attribution
            )
        }
    }

    private func persistNextSnapshot(scores: [MentionClusterScore], now: Date) throws {
        guard let scheduler else { return }
        let nextAsOf = scheduler.nextRunDate(after: now, config: scoringConfig)
        try scheduler.persistSnapshot(
            scores: scores,
            asOf: nextAsOf,
            halfLifeDays: scoringConfig.halfLifeDays
        )
    }
}

extension NewsBatchCache: NewsBatchCaching {}

extension NewsSourceAggregator: NewsEventProviding {
    static func newsTabDefault() -> NewsSourceAggregator {
        NewsSourceAggregator(
            sources: [
                RSSNewsSource(),
                GDELTNewsSource(),
                XNewsSource()
            ]
        )
    }

    static func builtInFallback() -> NewsSourceAggregator {
        NewsSourceAggregator(
            sources: [
                FixtureNewsSource()
            ]
        )
    }

    func fetchEvents(limit: Int) async throws -> [CrisisEvent] {
        try await fetchAll(limit: limit)
    }
}
