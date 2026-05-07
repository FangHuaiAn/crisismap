# News Source Multidimensional Redesign Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Refactor the iOS News pipeline to represent and enforce source diversity across structured source dimensions instead of a single source string.

**Architecture:** Add a nested `NewsSourceDescriptor` to `CrisisEvent`, preserve backward-compatible display fields, refactor source adapters to populate structured source metadata, then update aggregation and mention scoring to use multidimensional quotas and attribution-aware weighting.

**Tech Stack:** Swift 6, SwiftUI, SwiftData, Foundation, `URLSession`, existing `CrisisEvent`, `NewsSourceAggregator`, `MentionStore`, `MentionIndexCalculator`, and XCTest.

---

### Task 1: Add Structured News Source Model

**Files:**
- Create: `ios/CrisisMap/Models/NewsSourceDescriptor.swift`
- Modify: `ios/CrisisMap/Models/CrisisEvent.swift`
- Test: `ios/CrisisMapTests/NewsSourceDescriptorTests.swift`

**Step 1: Write the failing test**

```swift
func testCrisisEventKeepsDisplaySourceInSyncWithStructuredNewsSource() {
    let descriptor = NewsSourceDescriptor(
        displayName: "Reuters",
        kind: .wire,
        identity: "reuters",
        group: "reuters",
        attribution: .direct
    )

    let event = CrisisEvent(
        id: "id",
        title: "Title",
        summary: "Summary",
        category: .conflict,
        level: .high,
        location: nil,
        timestamp: "2026-04-13T00:00:00Z",
        source: "Reuters",
        sourceTier: .public,
        url: nil,
        actor: nil,
        entities: nil,
        newsSource: descriptor
    )

    XCTAssertEqual(event.source, "Reuters")
    XCTAssertEqual(event.newsSource?.identity, "reuters")
}
```

**Step 2: Run test to verify it fails**

Run:

```bash
cd /Users/fanghuaian/Documents/Projects/crisismap/ios && xcodebuild -project CrisisMap.xcodeproj -scheme CrisisMap -destination 'platform=iOS Simulator,name=iPhone 16e' CODE_SIGNING_ALLOWED=NO test -only-testing:CrisisMapTests/NewsSourceDescriptorTests
```

Expected: FAIL because the structured source model does not exist.

**Step 3: Write minimal implementation**

- Add `NewsSourceKind`
- Add `NewsSourceAttribution`
- Add `NewsSourceDescriptor`
- Extend `CrisisEvent` with optional `newsSource`
- Keep `source` as the compatibility/display label

**Step 4: Run test to verify it passes**

Run the same `xcodebuild` command.
Expected: PASS.

**Step 5: Commit**

```bash
git add ios/CrisisMap/Models/NewsSourceDescriptor.swift ios/CrisisMap/Models/CrisisEvent.swift ios/CrisisMapTests/NewsSourceDescriptorTests.swift
git commit -m "feat(ios): add structured news source descriptor"
```

### Task 2: Refactor RSS Normalization to Populate Structured Source Data

**Files:**
- Modify: `ios/CrisisMap/Services/NewsSources/RSSNewsSource.swift`
- Test: `ios/CrisisMapTests/RSSNewsSourceTests.swift`

**Step 1: Write the failing test**

```swift
func testMapsRSSItemWithDirectStructuredSource() async throws {
    let source = RSSNewsSource(session: .mocking(sampleReutersFeed))

    let events = try await source.fetch(limit: 10)

    XCTAssertEqual(events.first?.newsSource?.kind, .wire)
    XCTAssertEqual(events.first?.newsSource?.identity, "reuters")
    XCTAssertEqual(events.first?.newsSource?.attribution, .direct)
}
```

**Step 2: Run test to verify it fails**

Run:

```bash
xcodebuild -project /Users/fanghuaian/Documents/Projects/crisismap/ios/CrisisMap.xcodeproj -scheme CrisisMap -destination 'platform=iOS Simulator,name=iPhone 16e' CODE_SIGNING_ALLOWED=NO test -only-testing:CrisisMapTests/RSSNewsSourceTests
```

Expected: FAIL because RSS events do not populate `newsSource`.

**Step 3: Write minimal implementation**

- Extend RSS feed metadata with stable outlet identity and source kind
- Populate `newsSource`
- Keep `event.source == newsSource.displayName`

**Step 4: Run test to verify it passes**

Expected: PASS.

**Step 5: Commit**

```bash
git add ios/CrisisMap/Services/NewsSources/RSSNewsSource.swift ios/CrisisMapTests/RSSNewsSourceTests.swift
git commit -m "feat(ios): add structured rss source normalization"
```

### Task 3: Preserve Derived Source Dimensions in GDELT Normalization

**Files:**
- Modify: `ios/CrisisMap/Services/NewsSources/GDELTNewsSource.swift`
- Test: `ios/CrisisMapTests/GDELTNewsSourceTests.swift`

**Step 1: Write the failing test**

```swift
func testMapsGDELTArticleWithDerivedOutletMetadata() async throws {
    let source = GDELTNewsSource(session: .mocking(sampleGDELTResponse))

    let events = try await source.fetch(limit: 5)

    XCTAssertEqual(events.first?.newsSource?.kind, .aggregator)
    XCTAssertEqual(events.first?.newsSource?.attribution, .derived)
    XCTAssertEqual(events.first?.newsSource?.domain, "example.com")
    XCTAssertEqual(events.first?.newsSource?.languageCode, "en")
    XCTAssertEqual(events.first?.newsSource?.originCountry, "US")
}
```

**Step 2: Run test to verify it fails**

Run:

```bash
xcodebuild -project /Users/fanghuaian/Documents/Projects/crisismap/ios/CrisisMap.xcodeproj -scheme CrisisMap -destination 'platform=iOS Simulator,name=iPhone 16e' CODE_SIGNING_ALLOWED=NO test -only-testing:CrisisMapTests/GDELTNewsSourceTests
```

Expected: FAIL because GDELT drops derived source metadata.

**Step 3: Write minimal implementation**

- Parse domain from response and URL
- Preserve `domain`, `language`, and `sourcecountry`
- Populate derived `newsSource.identity` and `newsSource.group`
- Keep a human-readable compatibility `source`

**Step 4: Run test to verify it passes**

Expected: PASS.

**Step 5: Commit**

```bash
git add ios/CrisisMap/Services/NewsSources/GDELTNewsSource.swift ios/CrisisMapTests/GDELTNewsSourceTests.swift
git commit -m "feat(ios): preserve gdelt derived source metadata"
```

### Task 4: Refactor X Normalization to Separate Identity from Grouping

**Files:**
- Modify: `ios/CrisisMap/Services/NewsSources/XNewsSource.swift`
- Test: `ios/CrisisMapTests/XNewsSourceTests.swift`

**Step 1: Write the failing test**

```swift
func testMapsXEventWithHandleIdentityAndPlatformGroup() async throws {
    let source = XNewsSource(configuration: .init(xBearerToken: "token", xaiAPIKey: nil), session: .mocking(sampleXResponse))

    let events = try await source.fetch(limit: 5)

    XCTAssertEqual(events.first?.newsSource?.kind, .social)
    XCTAssertEqual(events.first?.newsSource?.group, "x")
    XCTAssertEqual(events.first?.newsSource?.authorHandle, "@BNONews")
}
```

**Step 2: Run test to verify it fails**

Run:

```bash
xcodebuild -project /Users/fanghuaian/Documents/Projects/crisismap/ios/CrisisMap.xcodeproj -scheme CrisisMap -destination 'platform=iOS Simulator,name=iPhone 16e' CODE_SIGNING_ALLOWED=NO test -only-testing:CrisisMapTests/XNewsSourceTests
```

Expected: FAIL because X events do not populate structured source fields.

**Step 3: Write minimal implementation**

- Populate `newsSource.kind = .social`
- Set `group = "x"`
- Preserve handle-level identity
- Keep display `source` synchronized

**Step 4: Run test to verify it passes**

Expected: PASS.

**Step 5: Commit**

```bash
git add ios/CrisisMap/Services/NewsSources/XNewsSource.swift ios/CrisisMapTests/XNewsSourceTests.swift
git commit -m "feat(ios): add structured x source normalization"
```

### Task 5: Add Multidimensional Quotas to News Aggregation

**Files:**
- Modify: `ios/CrisisMap/Services/NewsSources/NewsSourceAggregator.swift`
- Test: `ios/CrisisMapTests/NewsSourceAggregatorTests.swift`

**Step 1: Write the failing test**

```swift
func testLimitsDerivedAndSocialShareWhenAlternativesExist() async throws {
    let aggregator = NewsSourceAggregator(
        sources: [derivedHeavy, socialHeavy, directPublishers],
        sourceTimeout: .milliseconds(50),
        diversityPolicy: .init(
            maxGroupShare: 0.25,
            maxDerivedShare: 0.4,
            maxKindShare: [.social: 0.2, .aggregator: 0.35],
            minDistinctRegions: 3
        )
    )

    let events = try await aggregator.fetchAll(limit: 10)

    XCTAssertLessThanOrEqual(events.filter { $0.newsSource?.attribution == .derived }.count, 4)
    XCTAssertLessThanOrEqual(events.filter { $0.newsSource?.kind == .social }.count, 2)
}
```

Add companion tests for:

- quota by `newsSource.group`
- region backfill still works
- kind backfill fills missing `wire`/`publisher`/`social` categories when available

**Step 2: Run test to verify it fails**

Run:

```bash
xcodebuild -project /Users/fanghuaian/Documents/Projects/crisismap/ios/CrisisMap.xcodeproj -scheme CrisisMap -destination 'platform=iOS Simulator,name=iPhone 16e' CODE_SIGNING_ALLOWED=NO test -only-testing:CrisisMapTests/NewsSourceAggregatorTests
```

Expected: FAIL because the aggregator only understands source-string quotas.

**Step 3: Write minimal implementation**

- Replace flat source-share logic with multidimensional quota helpers
- Read `newsSource.group`, `newsSource.kind`, and `newsSource.attribution`
- Preserve region-floor behavior
- Keep freshness ordering as final tiebreaker

**Step 4: Run test to verify it passes**

Expected: PASS.

**Step 5: Commit**

```bash
git add ios/CrisisMap/Services/NewsSources/NewsSourceAggregator.swift ios/CrisisMapTests/NewsSourceAggregatorTests.swift
git commit -m "feat(ios): add multidimensional news source quotas"
```

### Task 6: Reduce False Multi-Source Confirmation in Mention Scoring

**Files:**
- Modify: `ios/CrisisMap/Services/MentionIndexCalculator.swift`
- Modify: `ios/CrisisMap/ViewModels/NewsViewModel.swift`
- Modify: `ios/CrisisMap/Services/MentionStore.swift`
- Test: `ios/CrisisMapTests/MentionIndexCalculatorTests.swift`
- Test: `ios/CrisisMapTests/NewsViewModelTests.swift`

**Step 1: Write the failing test**

```swift
func testDerivedMentionsCarryLowerWeightThanDirectMentions() {
    let direct = makeMention(sourceIdentity: "reuters", attribution: .direct, clusterId: "cluster")
    let derived = makeMention(sourceIdentity: "gdelt:reuters.com", attribution: .derived, clusterId: "cluster")

    let scores = calculator.calculate(mentions: [direct, derived], rules: [], asOf: referenceDate)

    XCTAssertLessThan(scores[0].score, 2.0)
}
```

Add a companion test verifying mention keys use stable structured identity rather than only `event.source`.

**Step 2: Run test to verify it fails**

Run:

```bash
xcodebuild -project /Users/fanghuaian/Documents/Projects/crisismap/ios/CrisisMap.xcodeproj -scheme CrisisMap -destination 'platform=iOS Simulator,name=iPhone 16e' CODE_SIGNING_ALLOWED=NO test -only-testing:CrisisMapTests/MentionIndexCalculatorTests -only-testing:CrisisMapTests/NewsViewModelTests
```

Expected: FAIL because direct and derived confirmations are treated too similarly.

**Step 3: Write minimal implementation**

- Extend mention identity helpers to prefer structured source identity
- Carry attribution metadata through mention derivation
- Apply a lower score multiplier for derived mentions

**Step 4: Run test to verify it passes**

Expected: PASS.

**Step 5: Commit**

```bash
git add ios/CrisisMap/Services/MentionIndexCalculator.swift ios/CrisisMap/ViewModels/NewsViewModel.swift ios/CrisisMap/Services/MentionStore.swift ios/CrisisMapTests/MentionIndexCalculatorTests.swift ios/CrisisMapTests/NewsViewModelTests.swift
git commit -m "feat(ios): reduce false confirmation from derived sources"
```

### Task 7: Run Full Verification

**Files:**
- Verify only

**Step 1: Run targeted News test suite**

Run:

```bash
xcodebuild -project /Users/fanghuaian/Documents/Projects/crisismap/ios/CrisisMap.xcodeproj -scheme CrisisMap -destination 'platform=iOS Simulator,name=iPhone 16e' CODE_SIGNING_ALLOWED=NO test -only-testing:CrisisMapTests/RSSNewsSourceTests -only-testing:CrisisMapTests/GDELTNewsSourceTests -only-testing:CrisisMapTests/XNewsSourceTests -only-testing:CrisisMapTests/NewsSourceAggregatorTests -only-testing:CrisisMapTests/MentionIndexCalculatorTests -only-testing:CrisisMapTests/NewsViewModelTests
```

Expected: PASS.

**Step 2: Run broader iOS test suite**

Run:

```bash
xcodebuild -project /Users/fanghuaian/Documents/Projects/crisismap/ios/CrisisMap.xcodeproj -scheme CrisisMap -destination 'platform=iOS Simulator,name=iPhone 16e' CODE_SIGNING_ALLOWED=NO test
```

Expected: PASS.

**Step 3: Review RSS source health before claiming success**

Run:

```bash
curl -I -L --max-time 8 https://feeds.bbci.co.uk/news/world/rss.xml
curl -I -L --max-time 8 https://www3.nhk.or.jp/rss/news/cat6.xml
curl -I -L --max-time 8 https://www.aljazeera.com/xml/rss/all.xml
curl -I -L --max-time 8 https://rss.dw.com/rdf/rss-en-top
```

Expected: reachable responses so the feed set remains viable.

**Step 4: Commit final verification state**

```bash
git add ios/CrisisMap
git commit -m "test(ios): verify multidimensional news source redesign"
```
