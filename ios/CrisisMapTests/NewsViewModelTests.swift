import XCTest
@testable import CrisisMap

@MainActor
final class NewsViewModelTests: XCTestCase {
    func testRefreshBuildsClustersFromProviderOutputAndCachesNormalizedEvents() async {
        let now = Date(timeIntervalSince1970: 1_742_995_200)
        let events = [makeEvent(
            id: "taiwan-1",
            title: "Taiwan Strait blockade drill raises tensions",
            summary: "Taipei tracks new Taiwan Strait military activity",
            source: "Reuters",
            timestamp: "2026-03-18T08:00:00Z"
        )]
        let provider = FakeNewsEventProvider(events: events)
        let cache = FakeNewsBatchCache()
        let vm = NewsViewModel(eventProvider: provider, batchCache: cache, eventLimit: 7)

        await vm.refresh(now: now)

        XCTAssertEqual(vm.filteredClusters.map(\.clusterId), ["taiwan-strait"])
        XCTAssertEqual(cache.savedEvents.map(\.id), ["taiwan-1"])
        XCTAssertEqual(cache.savedFetchedAt, now)
        let requestedLimits = await provider.requestedLimits()
        XCTAssertEqual(requestedLimits, [7])
        XCTAssertFalse(vm.isOffline)
        XCTAssertNil(vm.error)
    }

    func testRefreshFallsBackToCachedBatchWhenLiveFetchFails() async {
        let cachedEvents = [makeEvent(
            id: "taiwan-cached",
            title: "Taiwan Strait missile overflight prompts response",
            summary: "Taipei says the Taiwan Strait remains tense",
            source: "AP",
            timestamp: "2026-03-18T09:00:00Z"
        )]
        let provider = FakeNewsEventProvider(error: TestFailure("live fetch failed"))
        let cache = FakeNewsBatchCache(events: cachedEvents, fetchedAt: Date(timeIntervalSince1970: 1_742_995_260))
        let vm = NewsViewModel(eventProvider: provider, batchCache: cache)

        await vm.refresh(now: Date(timeIntervalSince1970: 1_742_995_320))

        XCTAssertEqual(vm.filteredClusters.map(\.clusterId), ["taiwan-strait"])
        XCTAssertEqual(vm.filteredClusters.first?.events.map(\.id), ["taiwan-cached"])
        XCTAssertTrue(vm.isOffline)
        XCTAssertNil(vm.error)
    }

    func testRefreshSetsBlockingErrorWhenLiveAndCacheBothFail() async {
        let provider = FakeNewsEventProvider(error: TestFailure("live fetch failed"))
        let cache = FakeNewsBatchCache(loadError: TestFailure("cache load failed"))
        let vm = NewsViewModel(eventProvider: provider, batchCache: cache)

        await vm.refresh(now: Date(timeIntervalSince1970: 1_742_995_320))

        XCTAssertTrue(vm.allClusters.isEmpty)
        XCTAssertFalse(vm.isOffline)
        XCTAssertEqual(vm.error, "live fetch failed")
    }

    func testProductionNewsSourceStackContainsApprovedSources() {
        let provider = NewsSourceAggregator.newsTabDefault()

        XCTAssertEqual(provider.sources.map(\.id), ["rss", "gdelt", "x-grok"])
    }

    func testTopClustersSortedByScoreDescending() {
        let vm = NewsViewModel()
        let scores = [
            MentionClusterScore(
                clusterId: "lower",
                label: "Lower",
                score: 1.2,
                sourceCount: 1,
                lastMentionAt: nil,
                regions: [.europe],
                topics: ["war"]
            ),
            MentionClusterScore(
                clusterId: "higher",
                label: "Higher",
                score: 3.4,
                sourceCount: 2,
                lastMentionAt: nil,
                regions: [.eastAsia],
                topics: ["geoeconomics"]
            )
        ]

        vm.apply(scores: scores, clusteredEvents: [
            makeClusteredEvent(id: "e1", clusterId: "lower", source: "A", timestamp: "2026-03-18T08:00:00Z"),
            makeClusteredEvent(id: "e2", clusterId: "higher", source: "B", timestamp: "2026-03-18T09:00:00Z")
        ])

        XCTAssertEqual(vm.filteredClusters.map(\.clusterId), ["higher", "lower"])
    }

    func testRegionAndTopicFiltersNarrowList() {
        let vm = NewsViewModel()
        let scores = [
            MentionClusterScore(
                clusterId: "eu",
                label: "EU",
                score: 2,
                sourceCount: 1,
                lastMentionAt: nil,
                regions: [.europe],
                topics: ["war"]
            ),
            MentionClusterScore(
                clusterId: "asia",
                label: "Asia",
                score: 2,
                sourceCount: 1,
                lastMentionAt: nil,
                regions: [.eastAsia],
                topics: ["trade"]
            )
        ]

        vm.apply(scores: scores, clusteredEvents: [
            makeClusteredEvent(id: "e1", clusterId: "eu", source: "A", timestamp: "2026-03-18T08:00:00Z"),
            makeClusteredEvent(id: "e2", clusterId: "asia", source: "B", timestamp: "2026-03-18T09:00:00Z")
        ])

        vm.selectedRegion = .eastAsia
        XCTAssertEqual(vm.filteredClusters.map(\.clusterId), ["asia"])

        vm.selectedRegion = .all
        vm.selectedTopic = "war"
        XCTAssertEqual(vm.filteredClusters.map(\.clusterId), ["eu"])
    }

    func testClusterDetailHasSourceCoverageAndRecentItems() {
        let vm = NewsViewModel()
        let scores = [
            MentionClusterScore(
                clusterId: "cluster",
                label: "Cluster",
                score: 5,
                sourceCount: 2,
                lastMentionAt: nil,
                regions: [.europe],
                topics: ["war"]
            )
        ]

        vm.apply(scores: scores, clusteredEvents: [
            makeClusteredEvent(id: "old", clusterId: "cluster", source: "Reuters", timestamp: "2026-03-10T08:00:00Z"),
            makeClusteredEvent(id: "new", clusterId: "cluster", source: "AP", timestamp: "2026-03-18T08:00:00Z")
        ])

        let cluster = vm.filteredClusters.first
        XCTAssertEqual(cluster?.sources, ["AP", "Reuters"])
        XCTAssertEqual(cluster?.events.first?.id, "new")
    }

    func testClusterSummariesExposeAttributionAndKindMix() {
        let vm = NewsViewModel()
        let scores = [
            MentionClusterScore(
                clusterId: "cluster",
                label: "Cluster",
                score: 5,
                sourceCount: 3,
                lastMentionAt: nil,
                regions: [.europe],
                topics: ["war"]
            )
        ]

        vm.apply(scores: scores, clusteredEvents: [
            makeClusteredEvent(
                id: "direct-wire",
                clusterId: "cluster",
                source: "Reuters",
                timestamp: "2026-03-18T10:00:00Z",
                newsSource: NewsSourceDescriptor(
                    displayName: "Reuters",
                    kind: .wire,
                    identity: "reuters",
                    group: "reuters",
                    attribution: .direct
                )
            ),
            makeClusteredEvent(
                id: "direct-social",
                clusterId: "cluster",
                source: "x:@alpha",
                timestamp: "2026-03-18T09:00:00Z",
                newsSource: NewsSourceDescriptor(
                    displayName: "x:@alpha",
                    kind: .social,
                    identity: "x:alpha",
                    group: "x",
                    attribution: .direct,
                    authorHandle: "@alpha"
                )
            ),
            makeClusteredEvent(
                id: "derived-agg",
                clusterId: "cluster",
                source: "GDELT",
                timestamp: "2026-03-18T08:00:00Z",
                newsSource: NewsSourceDescriptor(
                    displayName: "GDELT",
                    kind: .aggregator,
                    identity: "gdelt:example.com",
                    group: "gdelt:example.com",
                    attribution: .derived,
                    domain: "example.com"
                )
            )
        ])

        let cluster = vm.filteredClusters.first
        XCTAssertEqual(cluster?.attributionSummary, "2 direct · 1 derived")
        XCTAssertEqual(cluster?.sourceKindSummary, "wire · social · aggregator")
        XCTAssertEqual(cluster?.rowSourceSummary, "2 direct · 1 derived")
        XCTAssertEqual(
            cluster?.attributionSummary(locale: Locale(identifier: "zh-Hant-TW")),
            "2 直接來源 · 1 轉載彙整"
        )
        XCTAssertEqual(
            cluster?.sourceKindSummary(locale: Locale(identifier: "zh-Hant-TW")),
            "通訊社 · 社群 · 聚合器"
        )
        XCTAssertEqual(
            cluster?.rowSourceSummary(locale: Locale(identifier: "zh-Hant-TW")),
            "2 直接來源 · 1 轉載彙整"
        )
    }

    func testClusterRowSummaryFallsBackToKindWhenAttributionMixIsSingleMode() {
        let vm = NewsViewModel()
        let scores = [
            MentionClusterScore(
                clusterId: "cluster",
                label: "Cluster",
                score: 5,
                sourceCount: 2,
                lastMentionAt: nil,
                regions: [.europe],
                topics: ["war"]
            )
        ]

        vm.apply(scores: scores, clusteredEvents: [
            makeClusteredEvent(
                id: "direct-wire",
                clusterId: "cluster",
                source: "Reuters",
                timestamp: "2026-03-18T10:00:00Z",
                newsSource: NewsSourceDescriptor(
                    displayName: "Reuters",
                    kind: .wire,
                    identity: "reuters",
                    group: "reuters",
                    attribution: .direct
                )
            ),
            makeClusteredEvent(
                id: "direct-publisher",
                clusterId: "cluster",
                source: "France 24",
                timestamp: "2026-03-18T09:00:00Z",
                newsSource: NewsSourceDescriptor(
                    displayName: "France 24",
                    kind: .publisher,
                    identity: "france24",
                    group: "france24",
                    attribution: .direct
                )
            )
        ])

        let cluster = vm.filteredClusters.first
        XCTAssertEqual(cluster?.attributionSummary, "2 direct")
        XCTAssertEqual(cluster?.rowSourceSummary, "wire · publisher")
        XCTAssertEqual(
            cluster?.attributionSummary(locale: Locale(identifier: "zh-Hant-TW")),
            "2 直接來源"
        )
        XCTAssertEqual(
            cluster?.rowSourceSummary(locale: Locale(identifier: "zh-Hant-TW")),
            "通訊社 · 發行媒體"
        )
    }

    func testClusterDetailAttributionSummaryHiddenForSingleModeClusters() {
        let vm = NewsViewModel()
        let scores = [
            MentionClusterScore(
                clusterId: "cluster",
                label: "Cluster",
                score: 5,
                sourceCount: 2,
                lastMentionAt: nil,
                regions: [.europe],
                topics: ["war"]
            )
        ]

        vm.apply(scores: scores, clusteredEvents: [
            makeClusteredEvent(
                id: "direct-wire",
                clusterId: "cluster",
                source: "Reuters",
                timestamp: "2026-03-18T10:00:00Z",
                newsSource: NewsSourceDescriptor(
                    displayName: "Reuters",
                    kind: .wire,
                    identity: "reuters",
                    group: "reuters",
                    attribution: .direct
                )
            ),
            makeClusteredEvent(
                id: "direct-publisher",
                clusterId: "cluster",
                source: "France 24",
                timestamp: "2026-03-18T09:00:00Z",
                newsSource: NewsSourceDescriptor(
                    displayName: "France 24",
                    kind: .publisher,
                    identity: "france24",
                    group: "france24",
                    attribution: .direct
                )
            )
        ])

        let cluster = vm.filteredClusters.first
        XCTAssertNil(cluster?.detailAttributionSummary)
    }

    func testClusterDetailAttributionSummaryRemainsVisibleForMixedClusters() {
        let vm = NewsViewModel()
        let scores = [
            MentionClusterScore(
                clusterId: "cluster",
                label: "Cluster",
                score: 5,
                sourceCount: 2,
                lastMentionAt: nil,
                regions: [.europe],
                topics: ["war"]
            )
        ]

        vm.apply(scores: scores, clusteredEvents: [
            makeClusteredEvent(
                id: "direct-wire",
                clusterId: "cluster",
                source: "Reuters",
                timestamp: "2026-03-18T10:00:00Z",
                newsSource: NewsSourceDescriptor(
                    displayName: "Reuters",
                    kind: .wire,
                    identity: "reuters",
                    group: "reuters",
                    attribution: .direct
                )
            ),
            makeClusteredEvent(
                id: "derived-agg",
                clusterId: "cluster",
                source: "GDELT",
                timestamp: "2026-03-18T09:00:00Z",
                newsSource: NewsSourceDescriptor(
                    displayName: "GDELT",
                    kind: .aggregator,
                    identity: "gdelt:example.com",
                    group: "gdelt:example.com",
                    attribution: .derived,
                    domain: "example.com"
                )
            )
        ])

        let cluster = vm.filteredClusters.first
        XCTAssertEqual(cluster?.detailAttributionSummary, "1 direct · 1 derived")
        XCTAssertEqual(
            cluster?.detailAttributionSummary(locale: Locale(identifier: "zh-Hant-TW")),
            "1 直接來源 · 1 轉載彙整"
        )
    }

    private func makeEvent(
        id: String,
        title: String,
        summary: String,
        source: String,
        timestamp: String,
        newsSource: NewsSourceDescriptor? = nil
    ) -> CrisisEvent {
        CrisisEvent(
            id: id,
            title: title,
            summary: summary,
            category: .conflict,
            level: .high,
            location: nil,
            timestamp: timestamp,
            source: source,
            sourceTier: .public,
            url: nil,
            actor: nil,
            entities: nil,
            newsSource: newsSource
        )
    }

    private func makeClusteredEvent(
        id: String,
        clusterId: String,
        source: String,
        timestamp: String,
        newsSource: NewsSourceDescriptor? = nil
    ) -> ClusteredEvent {
        let event = makeEvent(
            id: id,
            title: "Title \(id)",
            summary: "Summary",
            source: source,
            timestamp: timestamp,
            newsSource: newsSource
        )

        return ClusteredEvent(
            event: event,
            clusterId: clusterId,
            clusterLabel: "Label \(clusterId)",
            regions: [.europe],
            topics: ["war"]
        )
    }
}

private final class FakeNewsEventProvider: NewsEventProviding, @unchecked Sendable {
    private let result: Result<[CrisisEvent], Error>
    private let requestedLimitsStore = RequestedLimitsStore()

    init(events: [CrisisEvent]) {
        result = .success(events)
    }

    init(error: Error) {
        result = .failure(error)
    }

    func fetchEvents(limit: Int) async throws -> [CrisisEvent] {
        await requestedLimitsStore.append(limit)
        return try result.get()
    }

    func requestedLimits() async -> [Int] {
        await requestedLimitsStore.snapshot()
    }
}

private actor RequestedLimitsStore {
    private var limits: [Int] = []

    func append(_ limit: Int) {
        limits.append(limit)
    }

    func snapshot() -> [Int] {
        limits
    }
}

@MainActor
private final class FakeNewsBatchCache: NewsBatchCaching {
    private let storedBatch: (events: [CrisisEvent], fetchedAt: Date)?
    private let loadError: Error?

    private(set) var savedEvents: [CrisisEvent] = []
    private(set) var savedFetchedAt: Date?

    init(
        events: [CrisisEvent]? = nil,
        fetchedAt: Date = .distantPast,
        loadError: Error? = nil
    ) {
        if let events {
            storedBatch = (events: events, fetchedAt: fetchedAt)
        } else {
            storedBatch = nil
        }
        self.loadError = loadError
    }

    func save(events: [CrisisEvent], fetchedAt: Date) throws {
        savedEvents = events
        savedFetchedAt = fetchedAt
    }

    func load() throws -> (events: [CrisisEvent], fetchedAt: Date)? {
        if let loadError {
            throw loadError
        }
        return storedBatch
    }
}

private struct TestFailure: LocalizedError {
    let message: String

    init(_ message: String) {
        self.message = message
    }

    var errorDescription: String? { message }
}
