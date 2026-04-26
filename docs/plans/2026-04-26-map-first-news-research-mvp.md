# Map-First News/Research MVP Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build a serverless MVP information flow where the map displays region-level markers derived from built-in News clusters and static Research articles.

**Architecture:** Keep News and Research as the source-of-truth view models, then add a small derived region intelligence layer for the map. The map renders five fixed region markers and opens a region sheet with top news clusters and recent think tank reports. Do not add country/city markers, dashboard metrics, or server dependencies in this pass.

**Tech Stack:** SwiftUI, MapKit, SwiftData, XCTest, existing `NewsViewModel`, `ResearchViewModel`, `Region`, `NewsClusterSummary`, and `ThinkTankArticle`.

---

### Task 1: Add Region Intelligence Summary Model

**Files:**
- Create: `ios/CrisisMap/Models/RegionIntelligenceSummary.swift`
- Create: `ios/CrisisMapTests/RegionIntelligenceSummaryTests.swift`

**Step 1: Write the failing tests**

Create `ios/CrisisMapTests/RegionIntelligenceSummaryTests.swift`:

```swift
import XCTest
@testable import CrisisMap

final class RegionIntelligenceSummaryTests: XCTestCase {
    func testBuildsOnlyConcreteRegionSummaries() {
        let summaries = RegionIntelligenceSummary.build(
            newsClusters: [
                makeCluster(id: "middle-east", regions: [.middleEast], score: 10),
                makeCluster(id: "europe", regions: [.europe], score: 5)
            ],
            researchArticles: [
                makeArticle(id: "r1", category: "middle_east", topics: ["Middle East"]),
                makeArticle(id: "r2", category: "china_indopacific", topics: ["Taiwan"])
            ],
            now: Date(timeIntervalSince1970: 1_774_800_000)
        )

        XCTAssertEqual(summaries.map(\.region), [.middleEast, .europe, .eastAsia, .africa, .americas])
        XCTAssertFalse(summaries.contains { $0.region == .all })
        XCTAssertEqual(summaries.first(where: { $0.region == .middleEast })?.newsClusterCount, 1)
        XCTAssertEqual(summaries.first(where: { $0.region == .middleEast })?.researchArticleCount, 1)
        XCTAssertEqual(summaries.first(where: { $0.region == .eastAsia })?.researchArticleCount, 1)
    }

    func testHeatScoreNormalizesAgainstLargestRegion() {
        let summaries = RegionIntelligenceSummary.build(
            newsClusters: [
                makeCluster(id: "a", regions: [.middleEast], score: 10),
                makeCluster(id: "b", regions: [.middleEast], score: 7),
                makeCluster(id: "c", regions: [.europe], score: 3)
            ],
            researchArticles: [],
            now: Date(timeIntervalSince1970: 1_774_800_000)
        )

        XCTAssertEqual(summaries.first(where: { $0.region == .middleEast })?.heatScore, 1.0)
        XCTAssertEqual(summaries.first(where: { $0.region == .europe })?.heatScore, 0.5)
        XCTAssertEqual(summaries.first(where: { $0.region == .africa })?.heatScore, 0.0)
    }

    private func makeCluster(id: String, regions: [Region], score: Double) -> NewsClusterSummary {
        NewsClusterSummary(
            clusterId: id,
            label: "Cluster \(id)",
            score: score,
            sourceCount: 2,
            lastMentionAt: Date(timeIntervalSince1970: 1_774_799_000),
            regions: regions,
            topics: ["topic"],
            sources: ["Reuters"],
            events: []
        )
    }

    private func makeArticle(id: String, category: String, topics: [String]) -> ThinkTankArticle {
        ThinkTankArticle(
            id: id,
            thinkTank: "RAND",
            title: "Report \(id)",
            url: "https://example.com/\(id)",
            date: "2026-04-01",
            summary: "Summary",
            category: category,
            status: "reviewed",
            topics: topics
        )
    }
}
```

**Step 2: Run test to verify it fails**

Run:

```bash
cd ios
xcodebuild test -project CrisisMap.xcodeproj -scheme CrisisMap -destination 'platform=iOS Simulator,name=iPhone Air' -only-testing:CrisisMapTests/RegionIntelligenceSummaryTests
```

Expected: fail because `RegionIntelligenceSummary` does not exist.

**Step 3: Add the model**

Create `ios/CrisisMap/Models/RegionIntelligenceSummary.swift`:

```swift
import Foundation

struct RegionMapCoordinate: Codable, Sendable, Equatable {
    let latitude: Double
    let longitude: Double
}

struct RegionIntelligenceSummary: Identifiable, Sendable, Equatable {
    let region: Region
    let coordinate: RegionMapCoordinate
    let newsClusterCount: Int
    let researchArticleCount: Int
    let topNewsClusters: [NewsClusterSummary]
    let recentResearchArticles: [ThinkTankArticle]
    let lastUpdatedAt: Date?
    let heatScore: Double

    var id: Region { region }

    var totalCount: Int {
        newsClusterCount + researchArticleCount
    }

    static func build(
        newsClusters: [NewsClusterSummary],
        researchArticles: [ThinkTankArticle],
        now: Date = .now
    ) -> [RegionIntelligenceSummary] {
        let regions = Region.mapMarkerRegions
        let rawCountsByRegion = Dictionary(uniqueKeysWithValues: regions.map { region in
            let news = newsClusters.filter { $0.regions.contains(region) }
            let research = researchArticles.filter { region.matchesArticle($0) }
            return (region, news.count + research.count)
        })
        let maxCount = max(rawCountsByRegion.values.max() ?? 0, 1)

        return regions.map { region in
            let news = newsClusters
                .filter { $0.regions.contains(region) }
                .sorted { $0.score > $1.score }
            let research = researchArticles
                .filter { region.matchesArticle($0) }
                .sorted { $0.date > $1.date }
            let lastNewsDate = news.compactMap(\.lastMentionAt).max()
            let heatScore = Double(rawCountsByRegion[region, default: 0]) / Double(maxCount)

            return RegionIntelligenceSummary(
                region: region,
                coordinate: region.mapCoordinate,
                newsClusterCount: news.count,
                researchArticleCount: research.count,
                topNewsClusters: Array(news.prefix(3)),
                recentResearchArticles: Array(research.prefix(3)),
                lastUpdatedAt: lastNewsDate ?? now,
                heatScore: heatScore
            )
        }
    }
}

extension Region {
    static var mapMarkerRegions: [Region] {
        [.middleEast, .europe, .eastAsia, .africa, .americas]
    }

    var mapCoordinate: RegionMapCoordinate {
        switch self {
        case .all:
            RegionMapCoordinate(latitude: 20, longitude: 0)
        case .middleEast:
            RegionMapCoordinate(latitude: 29.5, longitude: 45)
        case .europe:
            RegionMapCoordinate(latitude: 50, longitude: 20)
        case .eastAsia:
            RegionMapCoordinate(latitude: 30, longitude: 120)
        case .africa:
            RegionMapCoordinate(latitude: 3, longitude: 20)
        case .americas:
            RegionMapCoordinate(latitude: 15, longitude: -75)
        }
    }
}
```

**Step 4: Run test to verify it passes**

Run the same `xcodebuild test` command.

Expected: `RegionIntelligenceSummaryTests` passes.

**Step 5: Commit**

```bash
git add ios/CrisisMap/Models/RegionIntelligenceSummary.swift ios/CrisisMapTests/RegionIntelligenceSummaryTests.swift
git commit -m "feat: add region intelligence summaries"
```

---

### Task 2: Expose Map Summaries From CrisisMapView

**Files:**
- Modify: `ios/CrisisMap/Views/Map/CrisisMapView.swift`

**Step 1: Add view-model environments**

Modify `CrisisMapView` to read News and Research:

```swift
@Environment(NewsViewModel.self) private var newsVM
@Environment(ResearchViewModel.self) private var researchVM
@Environment(\.modelContext) private var modelContext
```

**Step 2: Replace event polling with News/Research refresh**

Remove the `EventsViewModel.startPolling()` dependency from map `onAppear`.

Add state:

```swift
@State private var didBootstrapSources = false
```

Add helper:

```swift
private var regionSummaries: [RegionIntelligenceSummary] {
    RegionIntelligenceSummary.build(
        newsClusters: newsVM.allClusters,
        researchArticles: researchVM.articles
    )
}

private func bootstrapSourcesIfNeeded() async {
    guard !didBootstrapSources else { return }
    didBootstrapSources = true
    newsVM.setModelContext(modelContext)
    researchVM.setModelContext(modelContext)
    await withTaskGroup(of: Void.self) { group in
        group.addTask { await newsVM.refresh() }
        group.addTask { await researchVM.loadData() }
    }
}
```

Use:

```swift
.task {
    await bootstrapSourcesIfNeeded()
}
```

**Step 3: Temporarily keep old event map code behind the new summary list**

In this task, do not delete `EventsViewModel` yet. Only ensure `regionSummaries` exists and sources load when the map appears. The marker replacement happens in Task 3.

**Step 4: Run focused tests**

Run:

```bash
cd ios
xcodebuild test -project CrisisMap.xcodeproj -scheme CrisisMap -destination 'platform=iOS Simulator,name=iPhone Air' -only-testing:CrisisMapTests/NewsViewModelTests -only-testing:CrisisMapTests/ResearchViewModelTopicsTests -only-testing:CrisisMapTests/RegionIntelligenceSummaryTests
```

Expected: all selected tests pass.

**Step 5: Commit**

```bash
git add ios/CrisisMap/Views/Map/CrisisMapView.swift
git commit -m "feat: load news and research for map"
```

---

### Task 3: Render Region Markers On The Map

**Files:**
- Create: `ios/CrisisMap/Views/Map/RegionMarkerView.swift`
- Modify: `ios/CrisisMap/Views/Map/CrisisMapView.swift`

**Step 1: Create the marker view**

Create `ios/CrisisMap/Views/Map/RegionMarkerView.swift`:

```swift
import SwiftUI

struct RegionMarkerView: View {
    let summary: RegionIntelligenceSummary

    private var markerSize: CGFloat {
        18 + CGFloat(summary.heatScore) * 22
    }

    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(Color.accentBlue.opacity(0.22 + summary.heatScore * 0.28))
                    .frame(width: markerSize * 1.8, height: markerSize * 1.8)
                    .blur(radius: 3)

                Circle()
                    .fill(Color.accentBlue)
                    .frame(width: markerSize, height: markerSize)

                Text("\(summary.totalCount)")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.white)
                    .minimumScaleFactor(0.6)
            }

            Text(summary.region.label)
                .font(.caption2.bold())
                .foregroundStyle(Color.textPrimary)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(Color.bgSecondary.opacity(0.85))
                .clipShape(Capsule())
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(summary.region.label), \(summary.newsClusterCount) news clusters, \(summary.researchArticleCount) research reports")
    }
}
```

**Step 2: Add MapKit coordinate bridge**

In `CrisisMapView.swift`, add:

```swift
private extension RegionMapCoordinate {
    var clLocationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
```

**Step 3: Replace event annotations with region annotations**

Change `mapContent` to:

```swift
private var mapContent: some View {
    Map(position: $position, selection: $selectedRegion) {
        ForEach(regionSummaries) { summary in
            Annotation(summary.region.label, coordinate: summary.coordinate.clLocationCoordinate, anchor: .center) {
                RegionMarkerView(summary: summary)
                    .onTapGesture {
                        selectedRegion = summary.region
                    }
            }
            .tag(summary.region)
        }
    }
    .mapStyle(.imagery(elevation: .realistic))
    .mapControlVisibility(.visible)
    .ignoresSafeArea(edges: .top)
}
```

Add state:

```swift
@State private var selectedRegion: Region?
```

Remove `selectedEventId` and event-specific camera logic in a later task only if the compiler confirms it is no longer referenced.

**Step 4: Update header count**

Replace event count text with:

```swift
Text("\(regionSummaries.reduce(0) { $0 + $1.totalCount }) items")
```

**Step 5: Build**

Run:

```bash
cd ios
xcodebuild -project CrisisMap.xcodeproj -scheme CrisisMap -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO build
```

Expected: build succeeds.

**Step 6: Commit**

```bash
git add ios/CrisisMap/Views/Map/RegionMarkerView.swift ios/CrisisMap/Views/Map/CrisisMapView.swift
git commit -m "feat: render region intelligence markers"
```

---

### Task 4: Add Region Intelligence Sheet

**Files:**
- Create: `ios/CrisisMap/Views/Map/RegionIntelligenceSheet.swift`
- Modify: `ios/CrisisMap/Views/Map/CrisisMapView.swift`

**Step 1: Create the sheet**

Create `ios/CrisisMap/Views/Map/RegionIntelligenceSheet.swift`:

```swift
import SwiftUI

struct RegionIntelligenceSheet: View {
    let summary: RegionIntelligenceSummary

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Label("\(summary.newsClusterCount) news", systemImage: "newspaper")
                        Spacer()
                        Label("\(summary.researchArticleCount) reports", systemImage: "book")
                    }
                    .font(.subheadline)
                    .foregroundStyle(Color.textSecondary)
                }

                if !summary.topNewsClusters.isEmpty {
                    Section("Top News Clusters") {
                        ForEach(summary.topNewsClusters) { cluster in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(cluster.label)
                                    .font(.headline)
                                Text("\(cluster.sourceCount) sources")
                                    .font(.caption)
                                    .foregroundStyle(Color.textSecondary)
                                if !cluster.topics.isEmpty {
                                    Text(cluster.topics.joined(separator: " · "))
                                        .font(.caption2)
                                        .foregroundStyle(Color.textSecondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }

                if !summary.recentResearchArticles.isEmpty {
                    Section("Recent Reports") {
                        ForEach(summary.recentResearchArticles) { article in
                            Link(destination: URL(string: article.url) ?? URL(string: "https://example.com")!) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(article.title)
                                        .font(.headline)
                                        .foregroundStyle(Color.textPrimary)
                                    Text(article.thinkTank)
                                        .font(.caption)
                                        .foregroundStyle(Color.textSecondary)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.bgPrimary)
            .navigationTitle(summary.region.label)
        }
    }
}
```

**Step 2: Present selected region sheet**

In `CrisisMapView.swift`, add:

```swift
.sheet(item: selectedRegionSummary) { summary in
    RegionIntelligenceSheet(summary: summary)
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .presentationBackground(Color.bgSecondary)
}
```

Add helper:

```swift
private var selectedRegionSummary: Binding<RegionIntelligenceSummary?> {
    Binding(
        get: {
            guard let selectedRegion else { return nil }
            return regionSummaries.first { $0.region == selectedRegion }
        },
        set: { summary in
            selectedRegion = summary?.region
        }
    )
}
```

**Step 3: Build**

Run:

```bash
cd ios
xcodebuild -project CrisisMap.xcodeproj -scheme CrisisMap -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO build
```

Expected: build succeeds.

**Step 4: Commit**

```bash
git add ios/CrisisMap/Views/Map/RegionIntelligenceSheet.swift ios/CrisisMap/Views/Map/CrisisMapView.swift
git commit -m "feat: show region intelligence sheet"
```

---

### Task 5: Remove Map Dependency On Server Events

**Files:**
- Modify: `ios/CrisisMap/Views/Map/CrisisMapView.swift`
- Optionally modify: `ios/CrisisMap/App/ContentView.swift`

**Step 1: Clean up event-specific state**

In `CrisisMapView.swift`, remove:

```swift
@Environment(EventsViewModel.self) private var viewModel
@State private var selectedEventId: String?
```

Remove:

```swift
.onAppear { viewModel.startPolling() }
.onDisappear { viewModel.stopPolling() }
.sheet(item: selectedEvent) { ... }
.onChange(of: viewModel.selectedEventId) { ... }
private var selectedEvent: Binding<CrisisEvent?> { ... }
```

**Step 2: Keep old Feed tab for now**

Do not remove `EventsViewModel` from `ContentView` or the Feed tab in this task. The goal is only to stop the primary map from requiring `/api/events`.

**Step 3: Build and run selected tests**

Run:

```bash
cd ios
xcodebuild test -project CrisisMap.xcodeproj -scheme CrisisMap -destination 'platform=iOS Simulator,name=iPhone Air' -only-testing:CrisisMapTests/RegionIntelligenceSummaryTests -only-testing:CrisisMapTests/NewsViewModelTests -only-testing:CrisisMapTests/ResearchViewModelTopicsTests
```

Expected: selected tests pass.

**Step 4: Commit**

```bash
git add ios/CrisisMap/Views/Map/CrisisMapView.swift
git commit -m "refactor: decouple map from server events"
```

---

### Task 6: Simulator Verification

**Files:**
- No source edits unless verification exposes a bug.

**Step 1: Build and run**

Run:

```bash
cd ios
xcodebuild -project CrisisMap.xcodeproj -scheme CrisisMap -destination 'platform=iOS Simulator,name=iPhone Air' CODE_SIGNING_ALLOWED=NO build
```

Then launch with XcodeBuildMCP or:

```bash
xcrun simctl launch booted com.crisismap.app
```

**Step 2: Verify UI**

Expected:

- Map tab shows five region markers.
- Marker count is nonzero when News/Research have loaded.
- Tapping a marker opens a region sheet.
- Sheet shows top news clusters and/or recent reports.
- The map works without `localhost:3000`.

**Step 3: Capture screenshot**

Capture an iOS simulator screenshot and keep the path for the final report.

**Step 4: Commit fixes if needed**

If verification requires small UI fixes:

```bash
git add ios/CrisisMap/Views/Map
git commit -m "fix: polish region map verification issues"
```

---

## Execution Notes

- Do not add new marker categories until this information flow works end to end.
- Do not add server APIs in this pass.
- Do not move News/Research fetching to a backend in this pass.
- If `ResearchViewModel.loadData()` is slow on map launch, keep the first version simple and rely on cache. Optimize concurrency later only if the simulator verification feels bad.
