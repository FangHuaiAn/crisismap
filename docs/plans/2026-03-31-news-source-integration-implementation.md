# News Source Integration Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Implement a dedicated iOS-side News ingestion pipeline for the `News` tab using `RSS`, `GDELT`, and `X/Grok`, while keeping the existing `/api/events` flow unchanged for the rest of the app.

**Architecture:** Add a News-only source layer under `ios/CrisisMap/Services/NewsSources/` that normalizes all provider output into `CrisisEvent`. Feed that normalized batch into the existing News clustering, mention dedup, and mention-index stack. Persist the last successful normalized batch in SwiftData so the `News` tab can rebuild ranked clusters when live fetch fails.

**Tech Stack:** Swift 6, SwiftUI, SwiftData, Foundation, `URLSession`, `XMLParser`-style RSS parsing or lightweight feed parsing, existing `CrisisEvent`, `NewsClusteringEngine`, `MentionStore`, `MentionIndexCalculator`, and `NewsPrecomputeScheduler`.

---

### Task 1: Add News Source Interfaces and Batch Cache Model

**Files:**
- Create: `ios/CrisisMap/Models/CachedNewsBatch.swift`
- Create: `ios/CrisisMap/Services/NewsSources/NewsDataSource.swift`
- Create: `ios/CrisisMap/Services/NewsSources/NewsBatchCache.swift`
- Modify: `ios/CrisisMap/App/CrisisMapApp.swift`
- Modify: `ios/CrisisMap/App/ContentView.swift`
- Modify: `ios/project.yml`
- Test: `ios/CrisisMapTests/NewsBatchCacheTests.swift`

**Step 1: Write the failing test**

```swift
func testRoundTripsNormalizedBatch() throws {
    let cache = NewsBatchCache(modelContext: modelContext)
    let events = [makeEvent(id: "rss:1"), makeEvent(id: "gdelt:1")]

    try cache.save(events: events, fetchedAt: referenceDate)
    let restored = try cache.load()

    XCTAssertEqual(restored?.events.map(\.id), ["rss:1", "gdelt:1"])
}
```

**Step 2: Run test to verify it fails**

Run:

```bash
cd /Users/fanghuaian/Documents/Projects/crisismap/ios && xcodegen generate
xcodebuild -project CrisisMap.xcodeproj -scheme CrisisMap -destination 'platform=iOS Simulator,name=iPhone 16e' CODE_SIGNING_ALLOWED=NO test -only-testing:CrisisMapTests/NewsBatchCacheTests
```

Expected: FAIL because `CachedNewsBatch` and `NewsBatchCache` do not exist.

**Step 3: Write minimal implementation**

Create:

- `CachedNewsBatch` SwiftData model with `key`, `fetchedAt`, `payload`
- `NewsDataSource` protocol:

```swift
protocol NewsDataSource: Sendable {
    var id: String { get }
    var name: String { get }
    var isEnabled: Bool { get }
    func fetch(limit: Int) async throws -> [CrisisEvent]
}
```

- `NewsBatchCache` with:

```swift
func save(events: [CrisisEvent], fetchedAt: Date = .now) throws
func load() throws -> (events: [CrisisEvent], fetchedAt: Date)?
func clear() throws
```

Update both app model containers to include `CachedNewsBatch.self`.

**Step 4: Run test to verify it passes**

Run the same `xcodebuild` command.
Expected: PASS.

**Step 5: Commit**

```bash
git add ios/CrisisMap/Models/CachedNewsBatch.swift ios/CrisisMap/Services/NewsSources/NewsDataSource.swift ios/CrisisMap/Services/NewsSources/NewsBatchCache.swift ios/CrisisMap/App/CrisisMapApp.swift ios/CrisisMap/App/ContentView.swift ios/project.yml ios/CrisisMapTests/NewsBatchCacheTests.swift
git commit -m "feat(ios): add news batch cache and source protocol"
```

### Task 2: Implement RSS News Source

**Files:**
- Create: `ios/CrisisMap/Services/NewsSources/NewsSourceHeuristics.swift`
- Create: `ios/CrisisMap/Services/NewsSources/RSSNewsSource.swift`
- Test: `ios/CrisisMapTests/RSSNewsSourceTests.swift`

**Step 1: Write the failing test**

```swift
func testMapsReutersItemToCrisisEvent() async throws {
    let source = RSSNewsSource(session: .mocking(sampleReutersFeed))
    let events = try await source.fetch(limit: 10)

    XCTAssertEqual(events.first?.source, "Reuters")
    XCTAssertEqual(events.first?.sourceTier, .public)
    XCTAssertNotNil(events.first?.url)
}
```

**Step 2: Run test to verify it fails**

Run:

```bash
xcodebuild -project /Users/fanghuaian/Documents/Projects/crisismap/ios/CrisisMap.xcodeproj -scheme CrisisMap -destination 'platform=iOS Simulator,name=iPhone 16e' CODE_SIGNING_ALLOWED=NO test -only-testing:CrisisMapTests/RSSNewsSourceTests
```

Expected: FAIL because `RSSNewsSource` does not exist.

**Step 3: Write minimal implementation**

Create a reusable heuristics file for:

- stable hash/id generation
- HTML stripping
- category inference
- threat-level inference hooks
- actor extraction helpers when useful

Implement `RSSNewsSource`:

- fixed feed list:
  - Reuters
  - AP News
  - BBC News
  - NHK World
  - Al Jazeera
- fetch all feeds in parallel
- parse feed items
- drop obviously non-geopolitical items
- normalize each item into `CrisisEvent`

**Step 4: Run test to verify it passes**

Expected: PASS for RSS mapping tests.

**Step 5: Commit**

```bash
git add ios/CrisisMap/Services/NewsSources/NewsSourceHeuristics.swift ios/CrisisMap/Services/NewsSources/RSSNewsSource.swift ios/CrisisMapTests/RSSNewsSourceTests.swift
git commit -m "feat(ios): add rss news source normalization"
```

### Task 3: Implement GDELT and X/Grok News Sources

**Files:**
- Create: `ios/CrisisMap/Services/NewsSources/GDELTNewsSource.swift`
- Create: `ios/CrisisMap/Services/NewsSources/XNewsSource.swift`
- Test: `ios/CrisisMapTests/GDELTNewsSourceTests.swift`
- Test: `ios/CrisisMapTests/XNewsSourceTests.swift`

**Step 1: Write the failing tests**

```swift
func testMapsGDELTArticleToCrisisEvent() async throws {
    let source = GDELTNewsSource(session: .mocking(sampleGDELTResponse))
    let events = try await source.fetch(limit: 5)

    XCTAssertEqual(events.first?.source, "GDELT")
    XCTAssertTrue(events.first?.id.hasPrefix("gdelt:") == true)
}

func testDisablesXSourceWithoutCredentials() async throws {
    let source = XNewsSource(configuration: .init(xBearerToken: nil, xaiAPIKey: nil))
    XCTAssertFalse(source.isEnabled)
}
```

**Step 2: Run tests to verify they fail**

Run:

```bash
xcodebuild -project /Users/fanghuaian/Documents/Projects/crisismap/ios/CrisisMap.xcodeproj -scheme CrisisMap -destination 'platform=iOS Simulator,name=iPhone 16e' CODE_SIGNING_ALLOWED=NO test -only-testing:CrisisMapTests/GDELTNewsSourceTests -only-testing:CrisisMapTests/XNewsSourceTests
```

Expected: FAIL because source types do not exist.

**Step 3: Write minimal implementation**

Implement `GDELTNewsSource`:

- build URL with crisis-focused query
- decode JSON article list
- map to `CrisisEvent`

Implement `XNewsSource`:

- read configuration from injected values first, environment second
- `isEnabled == true` only when `X_BEARER_TOKEN` or `XAI_API_KEY` is present
- prefer X recent search
- fallback to Grok `x_search`
- normalize to `CrisisEvent`

Keep `XNewsSource` source labels stable, for example:

```swift
source: "x:@DeItaone"
sourceTier: .private
```

**Step 4: Run tests to verify they pass**

Expected: PASS.

**Step 5: Commit**

```bash
git add ios/CrisisMap/Services/NewsSources/GDELTNewsSource.swift ios/CrisisMap/Services/NewsSources/XNewsSource.swift ios/CrisisMapTests/GDELTNewsSourceTests.swift ios/CrisisMapTests/XNewsSourceTests.swift
git commit -m "feat(ios): add gdelt and x news source adapters"
```

### Task 4: Implement News Source Aggregator

**Files:**
- Create: `ios/CrisisMap/Services/NewsSources/NewsSourceAggregator.swift`
- Test: `ios/CrisisMapTests/NewsSourceAggregatorTests.swift`

**Step 1: Write the failing tests**

```swift
func testReturnsPartialResultsWhenOneSourceFails() async throws {
    let aggregator = NewsSourceAggregator(
        sources: [
            FakeSource(id: "rss", events: [makeEvent(id: "rss:1")]),
            FakeSource(id: "gdelt", error: URLError(.timedOut))
        ],
        sourceTimeout: 0.2
    )

    let events = try await aggregator.fetchAll(limit: 20)
    XCTAssertEqual(events.map(\.id), ["rss:1"])
}
```

Add companion tests for:

- dedup by `event.id`
- sort by timestamp descending
- skip disabled sources

**Step 2: Run test to verify it fails**

Run:

```bash
xcodebuild -project /Users/fanghuaian/Documents/Projects/crisismap/ios/CrisisMap.xcodeproj -scheme CrisisMap -destination 'platform=iOS Simulator,name=iPhone 16e' CODE_SIGNING_ALLOWED=NO test -only-testing:CrisisMapTests/NewsSourceAggregatorTests
```

Expected: FAIL because aggregator does not exist.

**Step 3: Write minimal implementation**

Implement:

```swift
struct NewsSourceAggregator {
    let sources: [any NewsDataSource]
    let sourceTimeout: Duration

    func fetchAll(limit: Int) async throws -> [CrisisEvent]
}
```

Rules:

- run enabled sources concurrently
- timeout each source independently
- swallow source-local failures
- deduplicate by `id`
- sort newest first
- trim to limit

**Step 4: Run test to verify it passes**

Expected: PASS.

**Step 5: Commit**

```bash
git add ios/CrisisMap/Services/NewsSources/NewsSourceAggregator.swift ios/CrisisMapTests/NewsSourceAggregatorTests.swift
git commit -m "feat(ios): add fault-isolated news source aggregator"
```

### Task 5: Refactor NewsViewModel to Use Dedicated Sources and Cache Fallback

**Files:**
- Modify: `ios/CrisisMap/ViewModels/NewsViewModel.swift`
- Modify: `ios/CrisisMap/Views/News/NewsView.swift`
- Test: `ios/CrisisMapTests/NewsViewModelTests.swift`

**Step 1: Write the failing tests**

Add tests for:

```swift
func testRefreshBuildsClustersFromProviderOutput() async {
    let provider = FakeNewsEventProvider(events: sampleEvents)
    let vm = NewsViewModel(eventProvider: provider, scoringConfig: .default)

    await vm.refresh()

    XCTAssertEqual(vm.filteredClusters.first?.clusterId, "taiwan-strait")
}

func testRefreshFallsBackToCachedBatchWhenLiveFetchFails() async {
    let provider = FakeNewsEventProvider(error: URLError(.notConnectedToInternet))
    let cache = FakeNewsBatchCache(events: sampleEvents)
    let vm = NewsViewModel(eventProvider: provider, batchCache: cache, scoringConfig: .default)

    await vm.refresh()

    XCTAssertFalse(vm.allClusters.isEmpty)
    XCTAssertNil(vm.error)
}
```

**Step 2: Run tests to verify they fail**

Run:

```bash
xcodebuild -project /Users/fanghuaian/Documents/Projects/crisismap/ios/CrisisMap.xcodeproj -scheme CrisisMap -destination 'platform=iOS Simulator,name=iPhone 16e' CODE_SIGNING_ALLOWED=NO test -only-testing:CrisisMapTests/NewsViewModelTests
```

Expected: FAIL because `NewsViewModel` still requires injected events from `EventsViewModel`.

**Step 3: Write minimal implementation**

Refactor `NewsViewModel`:

- inject a `NewsEventProviding` dependency
- inject a `NewsBatchCaching` dependency
- replace:

```swift
func refresh(events: [CrisisEvent], now: Date = .now) async
```

with:

```swift
func refresh(now: Date = .now) async
```

Flow:

1. fetch normalized events from provider
2. save batch cache on success
3. cluster and score
4. on failure, try cached batch
5. only show blocking unavailable state when both fail

Update `NewsView` so it no longer triggers `eventsVM.refresh()` or reads `eventsVM.events`.

**Step 4: Run tests to verify they pass**

Expected: PASS.

**Step 5: Commit**

```bash
git add ios/CrisisMap/ViewModels/NewsViewModel.swift ios/CrisisMap/Views/News/NewsView.swift ios/CrisisMapTests/NewsViewModelTests.swift
git commit -m "feat(ios): connect news view model to dedicated source pipeline"
```

### Task 6: Wire Production Sources and App Defaults

**Files:**
- Modify: `ios/CrisisMap/ViewModels/NewsViewModel.swift`
- Modify: `ios/CrisisMap/App/CrisisMapApp.swift`
- Modify: `ios/CrisisMap/App/ContentView.swift`
- Modify: `ios/project.yml`

**Step 1: Write the failing smoke test or integration assertion**

If no additional XCTest is added, create a narrow integration test in `ios/CrisisMapTests/NewsViewModelTests.swift` that verifies the default provider stack can be constructed with injected fakes and does not depend on `EventsViewModel`.

**Step 2: Run the focused test to verify it fails**

Expected: FAIL until the production dependency wiring is complete.

**Step 3: Write minimal implementation**

Construct the default News stack from:

- `RSSNewsSource()`
- `GDELTNewsSource()`
- `XNewsSource()`
- `NewsSourceAggregator`
- `NewsBatchCache`

Ensure previews/in-memory containers still work after adding `CachedNewsBatch`.

If needed, regenerate the Xcode project after adding files:

```bash
cd /Users/fanghuaian/Documents/Projects/crisismap/ios && xcodegen generate
```

**Step 4: Run focused tests to verify pass**

Expected: PASS.

**Step 5: Commit**

```bash
git add ios/CrisisMap/ViewModels/NewsViewModel.swift ios/CrisisMap/App/CrisisMapApp.swift ios/CrisisMap/App/ContentView.swift ios/project.yml ios/CrisisMap.xcodeproj/project.pbxproj
git commit -m "feat(ios): wire production news sources into app"
```

### Task 7: Regression Verification and Simulator Smoke

**Files:**
- Modify: as needed for final test-only fixes

**Step 1: Run the full test suite**

Run:

```bash
xcodebuild -project /Users/fanghuaian/Documents/Projects/crisismap/ios/CrisisMap.xcodeproj -scheme CrisisMap -destination 'platform=iOS Simulator,name=iPhone 16e' CODE_SIGNING_ALLOWED=NO test
```

Expected: all `CrisisMapTests` pass, including the existing mention-index and clustering tests.

**Step 2: Run a build smoke**

Run:

```bash
xcodebuild -project /Users/fanghuaian/Documents/Projects/crisismap/ios/CrisisMap.xcodeproj -scheme CrisisMap -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO build
```

Expected: `BUILD SUCCEEDED`.

**Step 3: Launch a simulator smoke if available**

Run the existing simulator flow and verify:

- app launches
- `News` tab loads
- `Map`, `Feed`, `Dashboard`, and `Research` still open
- `News` no longer blocks on `/api/events`

**Step 4: Apply any final test-only fix**

Keep changes minimal and scoped to regressions found during verification.

**Step 5: Commit**

```bash
git add <changed-files>
git commit -m "test(ios): verify dedicated news source integration"
```
