# Research Tab Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a fourth "Research" tab to the CrisisMap iOS app that fetches think tank articles from Cloudflare, caches them with SwiftData, and lets users browse by region → topic → article list.

**Architecture:** Static JSON files on Cloudflare fetched via URLSession, cached in SwiftData for offline/incremental updates. New ResearchViewModel handles fetch + cache logic. Three-level NavigationStack: RegionList → TopicList → ArticleList. Extends existing Region enum with topic/category mapping.

**Tech Stack:** SwiftUI, SwiftData, URLSession, existing Region enum, existing Color+Theme

**Spec:** `docs/superpowers/specs/2026-03-11-research-tab-design.md`

---

## File Structure

### New Files

| File | Responsibility |
|------|---------------|
| `CrisisMap/Models/ThinkTankArticle.swift` | Codable structs: ThinkTankArticle, ThinkTankWeekly, WeekIndex, WeekEntry |
| `CrisisMap/Models/CachedWeekly.swift` | SwiftData @Model for offline cache |
| `CrisisMap/ViewModels/ResearchViewModel.swift` | Fetch, cache, filter logic |
| `CrisisMap/Views/Research/ResearchView.swift` | NavigationStack root — region list |
| `CrisisMap/Views/Research/TopicListView.swift` | Topics within a region |
| `CrisisMap/Views/Research/ArticleListView.swift` | Articles filtered by region+topic |
| `CrisisMap/Views/Research/ArticleRow.swift` | Single article row component |

### Modified Files

| File | Change |
|------|--------|
| `CrisisMap/Models/Region.swift` | Add `researchCategories` and `researchTopics` computed properties |
| `CrisisMap/Services/APIClient.swift` | Add `fetchWeekIndex()` and `fetchWeekly(week:)` methods |
| `CrisisMap/App/CrisisMapApp.swift` | Add ResearchViewModel, SwiftData ModelContainer |
| `CrisisMap/App/ContentView.swift` | Add fourth Research tab |
| `CrisisMap/Resources/Localizable.xcstrings` | Add research tab localization keys |

---

## Chunk 1: Data Layer

### Task 1: ThinkTankArticle Model

**Files:**
- Create: `CrisisMap/Models/ThinkTankArticle.swift`

- [ ] **Step 1: Create the model file**

```swift
import Foundation

struct WeekEntry: Codable, Sendable {
    let week: String
    let uploaded: String
}

struct WeekIndex: Codable, Sendable {
    let weeks: [WeekEntry]
}

struct ThinkTankArticle: Codable, Identifiable, Sendable {
    let id: String
    let thinkTank: String
    let title: String
    let url: String
    let date: String
    let summary: String
    let category: String
    let status: String
    let topics: [String]

    enum CodingKeys: String, CodingKey {
        case id
        case thinkTank = "think_tank"
        case title, url, date, summary, category, status, topics
    }
}

struct ThinkTankWeekly: Codable, Sendable {
    let week: String
    let startDate: String
    let endDate: String
    let generatedAt: String
    let articles: [ThinkTankArticle]

    enum CodingKeys: String, CodingKey {
        case week
        case startDate = "start_date"
        case endDate = "end_date"
        case generatedAt = "generated_at"
        case articles
    }
}
```

- [ ] **Step 2: Build to verify compilation**

Run: `cd iOS && xcodebuild -project CrisisMap.xcodeproj -scheme CrisisMap -destination 'platform=iOS Simulator,name=iPhone 16' build 2>&1 | tail -5`
Expected: BUILD SUCCEEDED

- [ ] **Step 3: Commit**

```bash
git add iOS/CrisisMap/Models/ThinkTankArticle.swift
git commit -m "feat(ios): add ThinkTankArticle codable models"
```

---

### Task 2: SwiftData CachedWeekly Model

**Files:**
- Create: `CrisisMap/Models/CachedWeekly.swift`

- [ ] **Step 1: Create the SwiftData model**

```swift
import Foundation
import SwiftData

@Model
final class CachedWeekly {
    @Attribute(.unique) var week: String
    var json: Data
    var uploadedAt: String
    var fetchedAt: Date

    init(week: String, json: Data, uploadedAt: String, fetchedAt: Date = .now) {
        self.week = week
        self.json = json
        self.uploadedAt = uploadedAt
        self.fetchedAt = fetchedAt
    }
}
```

- [ ] **Step 2: Build to verify compilation**

Run: `cd iOS && xcodebuild -project CrisisMap.xcodeproj -scheme CrisisMap -destination 'platform=iOS Simulator,name=iPhone 16' build 2>&1 | tail -5`
Expected: BUILD SUCCEEDED

- [ ] **Step 3: Commit**

```bash
git add iOS/CrisisMap/Models/CachedWeekly.swift
git commit -m "feat(ios): add CachedWeekly SwiftData model"
```

---

### Task 3: Extend Region with Research Mapping

**Files:**
- Modify: `CrisisMap/Models/Region.swift`

- [ ] **Step 1: Add research mapping properties**

Add to the `Region` enum, after the existing `matches(_:)` method:

```swift
/// Categories from think tank data that map to this region
var researchCategories: [String] {
    switch self {
    case .all:        []
    case .middleEast: ["middle_east"]
    case .europe:     ["europe"]
    case .eastAsia:   ["china_indopacific"]
    case .africa:     ["africa"]
    case .americas:   ["americas"]
    }
}

/// Topics from think tank data that map to this region
var researchTopics: [String] {
    switch self {
    case .all:        []
    case .middleEast: ["Middle East"]
    case .europe:     ["Europe", "Russia", "Ukraine", "NATO"]
    case .eastAsia:   ["China", "Taiwan", "Indo-Pacific"]
    case .africa:     []
    case .americas:   ["United States"]
    }
}

/// Check if a think tank article belongs to this region
func matchesArticle(_ article: ThinkTankArticle) -> Bool {
    if self == .all { return true }
    if researchCategories.contains(article.category) { return true }
    return !Set(researchTopics).intersection(article.topics).isEmpty
}
```

- [ ] **Step 2: Build to verify**

Run: `cd iOS && xcodebuild -project CrisisMap.xcodeproj -scheme CrisisMap -destination 'platform=iOS Simulator,name=iPhone 16' build 2>&1 | tail -5`
Expected: BUILD SUCCEEDED

- [ ] **Step 3: Commit**

```bash
git add iOS/CrisisMap/Models/Region.swift
git commit -m "feat(ios): add research topic/category mapping to Region"
```

---

### Task 4: Extend APIClient for Think Tank Data

**Files:**
- Modify: `CrisisMap/Services/APIClient.swift`

- [ ] **Step 1: Add think tank fetch methods**

Add to the `APIClient` actor, after the existing `fetchActors()` method:

```swift
// MARK: - Think Tank Data

private let thinkTankBaseURL = URL(string: "https://thinktankbriefdata.strataperture.net/2026")!

func fetchWeekIndex() async throws -> WeekIndex {
    let url = thinkTankBaseURL.appendingPathComponent("weeks.json")
    return try await fetchRaw(from: url)
}

func fetchWeekly(week: String) async throws -> ThinkTankWeekly {
    let url = thinkTankBaseURL.appendingPathComponent("\(week).json")
    return try await fetchRaw(from: url)
}

/// Fetch and decode JSON directly (no APIResponse wrapper — think tank data is raw JSON)
private func fetchRaw<T: Codable & Sendable>(from url: URL) async throws -> T {
    let (data, response) = try await session.data(from: url)

    guard let http = response as? HTTPURLResponse else {
        throw APIError.networkError(URLError(.badServerResponse))
    }

    guard http.statusCode == 200 else {
        throw APIError.serverError("HTTP \(http.statusCode)")
    }

    return try decoder.decode(T.self, from: data)
}
```

Note: Think tank data is raw JSON (not wrapped in `APIResponse`), so we need a separate `fetchRaw` method.

- [ ] **Step 2: Build to verify**

Run: `cd iOS && xcodebuild -project CrisisMap.xcodeproj -scheme CrisisMap -destination 'platform=iOS Simulator,name=iPhone 16' build 2>&1 | tail -5`
Expected: BUILD SUCCEEDED

- [ ] **Step 3: Commit**

```bash
git add iOS/CrisisMap/Services/APIClient.swift
git commit -m "feat(ios): add think tank data fetch methods to APIClient"
```

---

## Chunk 2: ViewModel

### Task 5: ResearchViewModel

**Files:**
- Create: `CrisisMap/ViewModels/ResearchViewModel.swift`

- [ ] **Step 1: Create the ViewModel**

```swift
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

    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }

    // MARK: - Computed Properties

    /// Regions with article counts, excluding regions with 0 articles
    var regionsWithCounts: [(region: Region, count: Int)] {
        Region.allCases.map { region in
            let count = region == .all
                ? articles.count
                : articles.filter { region.matchesArticle($0) }.count
            return (region, count)
        }
    }

    /// Topics available for the selected region, with counts, sorted by count descending
    var topicsForRegion: [(topic: String, count: Int)] {
        let regionArticles = articles.filter { selectedRegion.matchesArticle($0) }
        var topicCounts: [String: Int] = [:]
        for article in regionArticles {
            for topic in article.topics {
                topicCounts[topic, default: 0] += 1
            }
        }
        return topicCounts
            .map { (topic: $0.key, count: $0.value) }
            .sorted { $0.count > $1.count }
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
        } catch {
            self.error = error.localizedDescription
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

    // MARK: - Cache Logic

    private func fetchWithCache(weekIndex: WeekIndex) async throws -> [ThinkTankArticle] {
        guard let modelContext else {
            // No SwiftData context — fetch all without caching
            return try await fetchAllWeeks(weekIndex.weeks)
        }

        var allArticles: [ThinkTankArticle] = []

        // Fetch cached weeks
        let descriptor = FetchDescriptor<CachedWeekly>()
        let cachedWeeks = (try? modelContext.fetch(descriptor)) ?? []
        let cachedByWeek = Dictionary(uniqueKeysWithValues: cachedWeeks.map { ($0.week, $0) })

        // Determine which weeks need fetching
        await withTaskGroup(of: (String, [ThinkTankArticle])?.self) { group in
            for entry in weekIndex.weeks {
                if let cached = cachedByWeek[entry.week], cached.uploadedAt == entry.uploaded {
                    // Use cache
                    if let weekly = try? JSONDecoder().decode(ThinkTankWeekly.self, from: cached.json) {
                        allArticles.append(contentsOf: weekly.articles)
                    }
                } else {
                    // Need to fetch
                    group.addTask {
                        do {
                            let weekly = try await APIClient.shared.fetchWeekly(week: entry.week)
                            return (entry.week, weekly.articles)
                        } catch {
                            return nil // Skip failed weeks
                        }
                    }
                }
            }

            for await result in group {
                guard let (week, weekArticles) = result else { continue }
                allArticles.append(contentsOf: weekArticles)

                // Save to cache
                if let entry = weekIndex.weeks.first(where: { $0.week == week }) {
                    let jsonData = try? JSONEncoder().encode(
                        ThinkTankWeekly(week: week, startDate: "", endDate: "", generatedAt: "", articles: weekArticles)
                    )
                    if let jsonData {
                        if let existing = cachedByWeek[week] {
                            existing.json = jsonData
                            existing.uploadedAt = entry.uploaded
                            existing.fetchedAt = .now
                        } else {
                            let cached = CachedWeekly(week: week, json: jsonData, uploadedAt: entry.uploaded)
                            modelContext.insert(cached)
                        }
                    }
                }
            }
        }

        try? modelContext.save()
        return allArticles
    }

    private func fetchAllWeeks(_ entries: [WeekEntry]) async throws -> [ThinkTankArticle] {
        var allArticles: [ThinkTankArticle] = []
        await withTaskGroup(of: [ThinkTankArticle]?.self) { group in
            for entry in entries {
                group.addTask {
                    try? await APIClient.shared.fetchWeekly(week: entry.week).articles
                }
            }
            for await articles in group {
                if let articles { allArticles.append(contentsOf: articles) }
            }
        }
        return allArticles
    }

    private func loadFromCache() -> [ThinkTankArticle] {
        guard let modelContext else { return [] }
        let descriptor = FetchDescriptor<CachedWeekly>()
        guard let cachedWeeks = try? modelContext.fetch(descriptor) else { return [] }
        return cachedWeeks.compactMap { cached in
            try? JSONDecoder().decode(ThinkTankWeekly.self, from: cached.json).articles
        }.flatMap { $0 }
    }
}
```

- [ ] **Step 2: Build to verify**

Run: `cd iOS && xcodebuild -project CrisisMap.xcodeproj -scheme CrisisMap -destination 'platform=iOS Simulator,name=iPhone 16' build 2>&1 | tail -5`
Expected: BUILD SUCCEEDED

- [ ] **Step 3: Commit**

```bash
git add iOS/CrisisMap/ViewModels/ResearchViewModel.swift
git commit -m "feat(ios): add ResearchViewModel with SwiftData cache"
```

---

## Chunk 3: Views

### Task 6: ArticleRow Component

**Files:**
- Create: `CrisisMap/Views/Research/ArticleRow.swift`

- [ ] **Step 1: Create the article row view**

```swift
import SwiftUI

struct ArticleRow: View {
    let article: ThinkTankArticle

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Header: think tank · category · date
            HStack {
                Label(article.thinkTank, systemImage: "building.columns.fill")
                    .font(.caption)
                    .foregroundStyle(.textSecondary)

                Text("·")
                    .foregroundStyle(.textSecondary)

                Text(article.category)
                    .font(.caption)
                    .foregroundStyle(.textSecondary)

                Spacer()

                Text(article.date)
                    .font(.caption2)
                    .foregroundStyle(.textSecondary)
            }

            // Title
            Text(article.title)
                .font(.subheadline.bold())
                .foregroundStyle(.textPrimary)
                .lineLimit(2)

            // Summary
            if !article.summary.isEmpty {
                Text(article.summary)
                    .font(.caption)
                    .foregroundStyle(.textSecondary)
                    .lineLimit(2)
            }

            // Topics
            if !article.topics.isEmpty {
                HStack(spacing: 4) {
                    Image(systemName: "tag.fill")
                        .font(.caption2)
                        .foregroundStyle(.accentBlue)
                    Text(article.topics.joined(separator: " · "))
                        .font(.caption2)
                        .foregroundStyle(.accentBlue)
                        .lineLimit(1)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
```

- [ ] **Step 2: Build to verify**

Run: `cd iOS && xcodebuild -project CrisisMap.xcodeproj -scheme CrisisMap -destination 'platform=iOS Simulator,name=iPhone 16' build 2>&1 | tail -5`
Expected: BUILD SUCCEEDED

- [ ] **Step 3: Commit**

```bash
git add iOS/CrisisMap/Views/Research/ArticleRow.swift
git commit -m "feat(ios): add ArticleRow component"
```

---

### Task 7: ArticleListView

**Files:**
- Create: `CrisisMap/Views/Research/ArticleListView.swift`

- [ ] **Step 1: Create the article list view**

```swift
import SwiftUI

struct ArticleListView: View {
    @Environment(ResearchViewModel.self) private var viewModel
    let region: Region
    let topic: String?

    var articles: [ThinkTankArticle] {
        viewModel.articlesFor(region: region, topic: topic)
    }

    var body: some View {
        List(articles) { article in
            if let url = URL(string: article.url) {
                Link(destination: url) {
                    ArticleRow(article: article)
                }
            } else {
                ArticleRow(article: article)
            }
        }
        .listStyle(.plain)
        .navigationTitle(topic ?? region.label)
    }
}
```

- [ ] **Step 2: Build to verify**

Run: `cd iOS && xcodebuild -project CrisisMap.xcodeproj -scheme CrisisMap -destination 'platform=iOS Simulator,name=iPhone 16' build 2>&1 | tail -5`
Expected: BUILD SUCCEEDED

- [ ] **Step 3: Commit**

```bash
git add iOS/CrisisMap/Views/Research/ArticleListView.swift
git commit -m "feat(ios): add ArticleListView"
```

---

### Task 8: TopicListView

**Files:**
- Create: `CrisisMap/Views/Research/TopicListView.swift`

- [ ] **Step 1: Create the topic list view**

```swift
import SwiftUI

struct TopicListView: View {
    @Environment(ResearchViewModel.self) private var viewModel
    let region: Region

    var topics: [(topic: String, count: Int)] {
        let regionArticles = viewModel.articles.filter { region.matchesArticle($0) }
        var topicCounts: [String: Int] = [:]
        for article in regionArticles {
            for topic in article.topics {
                topicCounts[topic, default: 0] += 1
            }
        }
        return topicCounts
            .map { (topic: $0.key, count: $0.value) }
            .sorted { $0.count > $1.count }
    }

    var body: some View {
        List {
            // "All Topics" row
            NavigationLink {
                ArticleListView(region: region, topic: nil)
            } label: {
                HStack {
                    Label("research.allTopics", systemImage: "tray.full.fill")
                        .foregroundStyle(.textPrimary)
                    Spacer()
                    Text("\(viewModel.articles.filter { region.matchesArticle($0) }.count)")
                        .foregroundStyle(.textSecondary)
                }
            }

            // Individual topics
            ForEach(topics, id: \.topic) { item in
                NavigationLink {
                    ArticleListView(region: region, topic: item.topic)
                } label: {
                    HStack {
                        Text(item.topic)
                            .foregroundStyle(.textPrimary)
                        Spacer()
                        Text("\(item.count)")
                            .foregroundStyle(.textSecondary)
                    }
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle(region.label)
    }
}
```

- [ ] **Step 2: Build to verify**

Run: `cd iOS && xcodebuild -project CrisisMap.xcodeproj -scheme CrisisMap -destination 'platform=iOS Simulator,name=iPhone 16' build 2>&1 | tail -5`
Expected: BUILD SUCCEEDED

- [ ] **Step 3: Commit**

```bash
git add iOS/CrisisMap/Views/Research/TopicListView.swift
git commit -m "feat(ios): add TopicListView"
```

---

### Task 9: ResearchView (Root)

**Files:**
- Create: `CrisisMap/Views/Research/ResearchView.swift`

- [ ] **Step 1: Create the research root view**

```swift
import SwiftUI

struct ResearchView: View {
    @Environment(ResearchViewModel.self) private var viewModel

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.articles.isEmpty {
                    ProgressView("Loading...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = viewModel.error, viewModel.articles.isEmpty {
                    ContentUnavailableView {
                        Label("research.error", systemImage: "exclamationmark.triangle")
                    } description: {
                        Text(error)
                    } actions: {
                        Button("research.retry") {
                            Task { await viewModel.loadData() }
                        }
                    }
                } else {
                    regionList
                }
            }
            .navigationTitle("research.title")
            .toolbar {
                if viewModel.isOffline {
                    ToolbarItem(placement: .status) {
                        Label("research.offline", systemImage: "wifi.slash")
                            .font(.caption)
                            .foregroundStyle(.accentYellow)
                    }
                }
            }
        }
        .task {
            if viewModel.articles.isEmpty {
                await viewModel.loadData()
            }
        }
    }

    private var regionList: some View {
        List(viewModel.regionsWithCounts, id: \.region) { item in
            NavigationLink {
                if item.region == .all {
                    TopicListView(region: .all)
                } else {
                    TopicListView(region: item.region)
                }
            } label: {
                HStack {
                    Text(item.region.label)
                        .foregroundStyle(.textPrimary)
                    Spacer()
                    Text("\(item.count)")
                        .font(.subheadline)
                        .foregroundStyle(.textSecondary)
                }
            }
        }
        .listStyle(.plain)
        .refreshable {
            await viewModel.loadData()
        }
    }
}
```

- [ ] **Step 2: Build to verify**

Run: `cd iOS && xcodebuild -project CrisisMap.xcodeproj -scheme CrisisMap -destination 'platform=iOS Simulator,name=iPhone 16' build 2>&1 | tail -5`
Expected: BUILD SUCCEEDED

- [ ] **Step 3: Commit**

```bash
git add iOS/CrisisMap/Views/Research/ResearchView.swift
git commit -m "feat(ios): add ResearchView root with region list"
```

---

## Chunk 4: Integration & Localization

### Task 10: Wire Up App Entry Point

**Files:**
- Modify: `CrisisMap/App/CrisisMapApp.swift`
- Modify: `CrisisMap/App/ContentView.swift`

- [ ] **Step 1: Update CrisisMapApp.swift**

Replace the entire file content:

```swift
import SwiftUI
import SwiftData

@main
struct CrisisMapApp: App {
    @State private var eventsVM = EventsViewModel()
    @State private var marketsVM = MarketsViewModel()
    @State private var actorsVM = ActorsViewModel()
    @State private var researchVM = ResearchViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(eventsVM)
                .environment(marketsVM)
                .environment(actorsVM)
                .environment(researchVM)
                .preferredColorScheme(.dark)
        }
        .modelContainer(for: [CachedWeekly.self])
    }
}
```

- [ ] **Step 2: Update ContentView.swift**

Replace the entire file content:

```swift
import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedTab = 0
    @Environment(ResearchViewModel.self) private var researchVM
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        TabView(selection: $selectedTab) {
            CrisisMapView()
                .tabItem {
                    Label("tab.map", systemImage: "map.fill")
                }
                .tag(0)

            EventListView()
                .tabItem {
                    Label("tab.feed", systemImage: "list.bullet")
                }
                .tag(1)

            DashboardView()
                .tabItem {
                    Label("tab.dashboard", systemImage: "chart.bar.fill")
                }
                .tag(2)

            ResearchView()
                .tabItem {
                    Label("tab.research", systemImage: "book.fill")
                }
                .tag(3)
        }
        .tint(Color.accentBlue)
        .onAppear {
            researchVM.setModelContext(modelContext)
        }
    }
}

#Preview {
    ContentView()
        .environment(EventsViewModel())
        .environment(MarketsViewModel())
        .environment(ActorsViewModel())
        .environment(ResearchViewModel())
        .modelContainer(for: [CachedWeekly.self], inMemory: true)
}
```

- [ ] **Step 3: Build to verify**

Run: `cd iOS && xcodebuild -project CrisisMap.xcodeproj -scheme CrisisMap -destination 'platform=iOS Simulator,name=iPhone 16' build 2>&1 | tail -5`
Expected: BUILD SUCCEEDED

- [ ] **Step 4: Commit**

```bash
git add iOS/CrisisMap/App/CrisisMapApp.swift iOS/CrisisMap/App/ContentView.swift
git commit -m "feat(ios): integrate Research tab into app"
```

---

### Task 11: Add Localization Keys

**Files:**
- Modify: `CrisisMap/Resources/Localizable.xcstrings`

- [ ] **Step 1: Add localization keys**

Add the following keys to `Localizable.xcstrings`:

| Key | en | zh-Hant-TW |
|-----|----|------------|
| `tab.research` | Research | 研究 |
| `research.title` | Research | 智庫研究 |
| `research.allTopics` | All Topics | 所有主題 |
| `research.error` | Failed to Load | 載入失敗 |
| `research.retry` | Retry | 重試 |
| `research.offline` | Offline | 離線模式 |

- [ ] **Step 2: Build to verify**

Run: `cd iOS && xcodebuild -project CrisisMap.xcodeproj -scheme CrisisMap -destination 'platform=iOS Simulator,name=iPhone 16' build 2>&1 | tail -5`
Expected: BUILD SUCCEEDED

- [ ] **Step 3: Commit**

```bash
git add iOS/CrisisMap/Resources/Localizable.xcstrings
git commit -m "feat(ios): add Research tab localization keys"
```

---

### Task 12: Write README.md

**Files:**
- Create: `README.md` (project root, if not exists, or update iOS section)

- [ ] **Step 1: Write README covering the Research tab feature and overall iOS app**

Include:
- Project overview (CrisisMap iOS)
- Features (Map, Feed, Dashboard, Research)
- Research tab: data source, region → topic → article navigation, offline cache
- Cloudflare data format
- Setup instructions
- Architecture overview

- [ ] **Step 2: Commit**

```bash
git add README.md
git commit -m "docs: add README with Research tab documentation"
```
