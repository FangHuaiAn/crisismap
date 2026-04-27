import Foundation
import XCTest
@testable import CrisisMap

final class NewsSourceAggregatorTests: XCTestCase {
    func testReturnsPartialResultsWhenOneSourceFails() async throws {
        let good = FakeSource(
            id: "good",
            isEnabled: true,
            result: .success([makeEvent(id: "good:1", timestamp: "2026-03-18T11:00:00Z")])
        )
        let bad = FakeSource(
            id: "bad",
            isEnabled: true,
            result: .failure(MockError.failed)
        )
        let aggregator = NewsSourceAggregator(
            sources: [good, bad],
            sourceTimeout: .milliseconds(50)
        )

        let events = try await aggregator.fetchAll(limit: 20)
        let goodFetchCount = await good.fetchCount()
        let badFetchCount = await bad.fetchCount()

        XCTAssertEqual(events.map(\.id), ["good:1"])
        XCTAssertEqual(goodFetchCount, 1)
        XCTAssertEqual(badFetchCount, 1)
    }

    func testReturnsEmptyBatchWhenSourceTimesOut() async throws {
        let slow = HangingSource(id: "slow")
        let aggregator = NewsSourceAggregator(
            sources: [slow],
            sourceTimeout: .milliseconds(20)
        )

        let events = try await aggregator.fetchAll(limit: 20)
        let slowFetchCount = await slow.fetchCount()

        XCTAssertTrue(events.isEmpty)
        XCTAssertEqual(slowFetchCount, 1)
    }

    func testTimeoutDoesNotWaitForNonCooperativeSourceCancellation() async throws {
        let stubborn = StubbornSource(id: "stubborn")
        let aggregator = NewsSourceAggregator(
            sources: [stubborn],
            sourceTimeout: .milliseconds(20)
        )
        let clock = ContinuousClock()
        let start = clock.now

        let events = try await aggregator.fetchAll(limit: 20)
        let elapsed = start.duration(to: clock.now)

        XCTAssertTrue(events.isEmpty)
        XCTAssertLessThan(elapsed, .milliseconds(150))
    }

    func testDedupsByEventID() async throws {
        let newer = makeEvent(id: "dup:1", timestamp: "2026-03-18T12:00:00Z", title: "Newer")
        let older = makeEvent(id: "dup:1", timestamp: "2026-03-18T11:00:00Z", title: "Older")
        let first = FakeSource(id: "first", isEnabled: true, result: .success([older]))
        let second = FakeSource(id: "second", isEnabled: true, result: .success([newer]))
        let aggregator = NewsSourceAggregator(sources: [first, second], sourceTimeout: .milliseconds(50))

        let events = try await aggregator.fetchAll(limit: 20)

        XCTAssertEqual(events.count, 1)
        XCTAssertEqual(events.first?.id, "dup:1")
        XCTAssertEqual(events.first?.title, "Newer")
    }

    func testSortsByTimestampDescending() async throws {
        let oldest = FakeSource(
            id: "oldest",
            isEnabled: true,
            result: .success([makeEvent(id: "oldest:1", timestamp: "2026-03-18T09:00:00Z")])
        )
        let newest = FakeSource(
            id: "newest",
            isEnabled: true,
            result: .success([makeEvent(id: "newest:1", timestamp: "2026-03-18T12:00:00Z")])
        )
        let middle = FakeSource(
            id: "middle",
            isEnabled: true,
            result: .success([makeEvent(id: "middle:1", timestamp: "2026-03-18T11:00:00Z")])
        )
        let aggregator = NewsSourceAggregator(
            sources: [oldest, newest, middle],
            sourceTimeout: .milliseconds(50)
        )

        let events = try await aggregator.fetchAll(limit: 20)

        XCTAssertEqual(events.map(\.id), ["newest:1", "middle:1", "oldest:1"])
    }

    func testInfersPhysicalLocationBeforeReturningNewsEvents() async throws {
        let source = FakeSource(
            id: "mali",
            isEnabled: true,
            result: .success([
                makeEvent(
                    id: "mali:1",
                    timestamp: "2026-03-18T12:00:00Z",
                    title: "What's driving attacks against gov't and Russian forces in Mali?",
                    summary: "Russian personnel remain exposed to attacks in Mali."
                )
            ])
        )
        let aggregator = NewsSourceAggregator(
            sources: [source],
            sourceTimeout: .milliseconds(50),
            diversityPolicy: .init(minDistinctRegions: 0)
        )

        let events = try await aggregator.fetchAll(limit: 10)
        let location = try XCTUnwrap(events.first?.location)

        XCTAssertEqual(location.name, "Mali")
        XCTAssertEqual(location.country, "ML")
        XCTAssertEqual(location.lat, 17.5707, accuracy: 0.0001)
        XCTAssertEqual(location.lng, -3.9962, accuracy: 0.0001)
    }

    func testSkipsDisabledSources() async throws {
        let enabled = FakeSource(
            id: "enabled",
            isEnabled: true,
            result: .success([makeEvent(id: "enabled:1", timestamp: "2026-03-18T11:00:00Z")])
        )
        let disabled = FakeSource(
            id: "disabled",
            isEnabled: false,
            result: .success([makeEvent(id: "disabled:1", timestamp: "2026-03-18T12:00:00Z")])
        )
        let aggregator = NewsSourceAggregator(
            sources: [disabled, enabled],
            sourceTimeout: .milliseconds(50)
        )

        let events = try await aggregator.fetchAll(limit: 20)
        let enabledFetchCount = await enabled.fetchCount()
        let disabledFetchCount = await disabled.fetchCount()

        XCTAssertEqual(events.map(\.id), ["enabled:1"])
        XCTAssertEqual(enabledFetchCount, 1)
        XCTAssertEqual(disabledFetchCount, 0)
    }

    func testTrimsToRequestedLimit() async throws {
        let source = FakeSource(
            id: "source",
            isEnabled: true,
            result: .success([
                makeEvent(id: "event:3", timestamp: "2026-03-18T12:00:00Z"),
                makeEvent(id: "event:2", timestamp: "2026-03-18T11:00:00Z"),
                makeEvent(id: "event:1", timestamp: "2026-03-18T10:00:00Z")
            ])
        )
        let aggregator = NewsSourceAggregator(sources: [source], sourceTimeout: .milliseconds(50))

        let events = try await aggregator.fetchAll(limit: 2)

        XCTAssertEqual(events.map(\.id), ["event:3", "event:2"])
    }

    func testSourceQuotaLimitsSingleSourceDominanceWhenAlternativesExist() async throws {
        let dominant = FakeSource(
            id: "dominant",
            isEnabled: true,
            result: .success([
                makeEvent(id: "a:4", timestamp: "2026-03-18T12:00:00Z", source: "Reuters"),
                makeEvent(id: "a:3", timestamp: "2026-03-18T11:00:00Z", source: "Reuters"),
                makeEvent(id: "a:2", timestamp: "2026-03-18T10:00:00Z", source: "Reuters"),
                makeEvent(id: "a:1", timestamp: "2026-03-18T09:00:00Z", source: "Reuters")
            ])
        )
        let secondary = FakeSource(
            id: "secondary",
            isEnabled: true,
            result: .success([
                makeEvent(id: "b:2", timestamp: "2026-03-18T08:00:00Z", source: "BBC News"),
                makeEvent(id: "b:1", timestamp: "2026-03-18T07:00:00Z", source: "BBC News")
            ])
        )
        let tertiary = FakeSource(
            id: "tertiary",
            isEnabled: true,
            result: .success([
                makeEvent(id: "c:2", timestamp: "2026-03-18T06:00:00Z", source: "DW"),
                makeEvent(id: "c:1", timestamp: "2026-03-18T05:00:00Z", source: "DW")
            ])
        )
        let aggregator = NewsSourceAggregator(
            sources: [dominant, secondary, tertiary],
            sourceTimeout: .milliseconds(50),
            diversityPolicy: .init(maxSourceShare: 0.33, minDistinctRegions: 0)
        )

        let events = try await aggregator.fetchAll(limit: 6)
        let dominantCount = events.filter { $0.source == "Reuters" }.count

        XCTAssertEqual(events.count, 6)
        XCTAssertLessThanOrEqual(dominantCount, 2)
    }

    func testTreatsAllXHandlesAsSameQuotaBucket() async throws {
        let social = FakeSource(
            id: "x",
            isEnabled: true,
            result: .success([
                makeEvent(id: "x:4", timestamp: "2026-03-18T12:00:00Z", source: "x:@alpha"),
                makeEvent(id: "x:3", timestamp: "2026-03-18T11:00:00Z", source: "x:@bravo"),
                makeEvent(id: "x:2", timestamp: "2026-03-18T10:00:00Z", source: "x:@charlie"),
                makeEvent(id: "x:1", timestamp: "2026-03-18T09:00:00Z", source: "x:@delta")
            ])
        )
        let wireMix = FakeSource(
            id: "wire-mix",
            isEnabled: true,
            result: .success([
                makeEvent(id: "wire:3", timestamp: "2026-03-18T08:00:00Z", source: "Reuters"),
                makeEvent(id: "wire:2", timestamp: "2026-03-18T07:00:00Z", source: "BBC News"),
                makeEvent(id: "wire:1", timestamp: "2026-03-18T06:00:00Z", source: "DW")
            ])
        )
        let aggregator = NewsSourceAggregator(
            sources: [social, wireMix],
            sourceTimeout: .milliseconds(50),
            diversityPolicy: .init(maxSourceShare: 0.4, minDistinctRegions: 0)
        )

        let events = try await aggregator.fetchAll(limit: 5)
        let xCount = events.filter { $0.source.lowercased().hasPrefix("x:") }.count

        XCTAssertEqual(events.count, 5)
        XCTAssertLessThanOrEqual(xCount, 2)
    }

    func testRegionFloorBackfillsMissingRegionsWhenAvailable() async throws {
        let europe = FakeSource(
            id: "europe",
            isEnabled: true,
            result: .success([
                makeEvent(
                    id: "eu:2",
                    timestamp: "2026-03-18T12:00:00Z",
                    source: "Reuters",
                    title: "Europe update",
                    summary: "Ukraine conflict escalates near Kyiv"
                ),
                makeEvent(
                    id: "eu:1",
                    timestamp: "2026-03-18T11:00:00Z",
                    source: "BBC News",
                    title: "Europe briefing",
                    summary: "NATO meets as tensions rise in eastern Europe"
                )
            ])
        )
        let eastAsia = FakeSource(
            id: "east-asia",
            isEnabled: true,
            result: .success([
                makeEvent(
                    id: "asia:1",
                    timestamp: "2026-03-18T10:00:00Z",
                    source: "NHK World",
                    title: "East Asia flash",
                    summary: "Taiwan and China navies report new standoff"
                )
            ])
        )
        let middleEast = FakeSource(
            id: "middle-east",
            isEnabled: true,
            result: .success([
                makeEvent(
                    id: "me:1",
                    timestamp: "2026-03-18T09:00:00Z",
                    source: "Al Jazeera",
                    title: "Middle East flash",
                    summary: "Iran missile alerts trigger regional military response"
                )
            ])
        )
        let aggregator = NewsSourceAggregator(
            sources: [europe, eastAsia, middleEast],
            sourceTimeout: .milliseconds(50),
            diversityPolicy: .init(maxSourceShare: 1.0, minDistinctRegions: 3)
        )

        let events = try await aggregator.fetchAll(limit: 3)
        let ids = events.map(\.id)

        XCTAssertEqual(ids, ["eu:2", "asia:1", "me:1"])
        XCTAssertFalse(ids.contains("eu:1"))
    }

    func testLimitsDerivedAndSocialShareWhenAlternativesExist() async throws {
        let derivedHeavy = FakeSource(
            id: "derived",
            isEnabled: true,
            result: .success([
                makeEvent(
                    id: "derived:4",
                    timestamp: "2026-03-18T12:00:00Z",
                    source: "GDELT",
                    newsSource: makeNewsSource(
                        displayName: "GDELT",
                        kind: .aggregator,
                        identity: "gdelt:source-1",
                        group: "gdelt:source-1",
                        attribution: .derived
                    )
                ),
                makeEvent(
                    id: "derived:3",
                    timestamp: "2026-03-18T11:00:00Z",
                    source: "GDELT",
                    newsSource: makeNewsSource(
                        displayName: "GDELT",
                        kind: .aggregator,
                        identity: "gdelt:source-2",
                        group: "gdelt:source-2",
                        attribution: .derived
                    )
                ),
                makeEvent(
                    id: "derived:2",
                    timestamp: "2026-03-18T10:00:00Z",
                    source: "GDELT",
                    newsSource: makeNewsSource(
                        displayName: "GDELT",
                        kind: .aggregator,
                        identity: "gdelt:source-3",
                        group: "gdelt:source-3",
                        attribution: .derived
                    )
                ),
                makeEvent(
                    id: "derived:1",
                    timestamp: "2026-03-18T09:00:00Z",
                    source: "GDELT",
                    newsSource: makeNewsSource(
                        displayName: "GDELT",
                        kind: .aggregator,
                        identity: "gdelt:source-4",
                        group: "gdelt:source-4",
                        attribution: .derived
                    )
                )
            ])
        )
        let socialHeavy = FakeSource(
            id: "social",
            isEnabled: true,
            result: .success([
                makeEvent(
                    id: "social:3",
                    timestamp: "2026-03-18T08:00:00Z",
                    source: "x:@alpha",
                    newsSource: makeNewsSource(
                        displayName: "x:@alpha",
                        kind: .social,
                        identity: "x:alpha",
                        group: "x",
                        attribution: .direct,
                        authorHandle: "@alpha"
                    )
                ),
                makeEvent(
                    id: "social:2",
                    timestamp: "2026-03-18T07:00:00Z",
                    source: "x:@bravo",
                    newsSource: makeNewsSource(
                        displayName: "x:@bravo",
                        kind: .social,
                        identity: "x:bravo",
                        group: "x",
                        attribution: .direct,
                        authorHandle: "@bravo"
                    )
                ),
                makeEvent(
                    id: "social:1",
                    timestamp: "2026-03-18T06:00:00Z",
                    source: "x:@charlie",
                    newsSource: makeNewsSource(
                        displayName: "x:@charlie",
                        kind: .social,
                        identity: "x:charlie",
                        group: "x",
                        attribution: .direct,
                        authorHandle: "@charlie"
                    )
                )
            ])
        )
        let directPublishers = FakeSource(
            id: "direct",
            isEnabled: true,
            result: .success([
                makeEvent(
                    id: "direct:3",
                    timestamp: "2026-03-18T05:00:00Z",
                    source: "Reuters",
                    title: "Europe update",
                    summary: "Ukraine conflict escalates near Kyiv",
                    newsSource: makeNewsSource(
                        displayName: "Reuters",
                        kind: .wire,
                        identity: "reuters",
                        group: "reuters",
                        attribution: .direct
                    )
                ),
                makeEvent(
                    id: "direct:2",
                    timestamp: "2026-03-18T04:00:00Z",
                    source: "BBC News",
                    title: "East Asia update",
                    summary: "Taiwan and China navies report new standoff",
                    newsSource: makeNewsSource(
                        displayName: "BBC News",
                        kind: .publisher,
                        identity: "bbc-news",
                        group: "bbc-news",
                        attribution: .direct
                    )
                ),
                makeEvent(
                    id: "direct:1",
                    timestamp: "2026-03-18T03:00:00Z",
                    source: "Al Jazeera",
                    title: "Middle East update",
                    summary: "Iran missile alerts trigger regional response",
                    newsSource: makeNewsSource(
                        displayName: "Al Jazeera",
                        kind: .publisher,
                        identity: "al-jazeera",
                        group: "al-jazeera",
                        attribution: .direct
                    )
                )
            ])
        )
        let aggregator = NewsSourceAggregator(
            sources: [derivedHeavy, socialHeavy, directPublishers],
            sourceTimeout: .milliseconds(50),
            diversityPolicy: .init(
                maxSourceShare: 1.0,
                maxKindShare: [.social: 0.2, .aggregator: 0.4],
                maxDerivedShare: 0.4,
                minDistinctRegions: 0
            )
        )

        let events = try await aggregator.fetchAll(limit: 10)
        let derivedCount = events.filter { $0.newsSource?.attribution == .derived }.count
        let socialCount = events.filter { $0.newsSource?.kind == .social }.count

        XCTAssertLessThanOrEqual(derivedCount, 4)
        XCTAssertLessThanOrEqual(socialCount, 2)
    }

    func testNearDuplicateDedupePrefersDirectAttributionOverDerivedCopy() async throws {
        let direct = FakeSource(
            id: "direct",
            isEnabled: true,
            result: .success([
                makeEvent(
                    id: "direct:1",
                    timestamp: "2026-03-18T12:00:00Z",
                    source: "Reuters",
                    title: "Missile strike raises tensions near Tehran",
                    summary: "Officials report a military escalation after the latest attack.",
                    url: "https://www.reuters.com/world/example-1",
                    newsSource: makeNewsSource(
                        displayName: "Reuters",
                        kind: .wire,
                        identity: "reuters",
                        group: "reuters",
                        attribution: .direct
                    )
                )
            ])
        )
        let derived = FakeSource(
            id: "derived",
            isEnabled: true,
            result: .success([
                makeEvent(
                    id: "derived:1",
                    timestamp: "2026-03-18T11:59:00Z",
                    source: "GDELT",
                    title: "Missile strike raises tensions near Tehran",
                    summary: "Missile strike raises tensions near Tehran",
                    url: "https://www.reuters.com/world/example-1",
                    newsSource: makeNewsSource(
                        displayName: "GDELT",
                        kind: .aggregator,
                        identity: "gdelt:reuters.com",
                        group: "gdelt:reuters.com",
                        attribution: .derived
                    )
                )
            ])
        )
        let aggregator = NewsSourceAggregator(
            sources: [direct, derived],
            sourceTimeout: .milliseconds(50)
        )

        let events = try await aggregator.fetchAll(limit: 10)

        XCTAssertEqual(events.map(\.id), ["direct:1"])
        XCTAssertEqual(events.first?.newsSource?.attribution, .direct)
    }

    func testKindFloorBackfillsMissingKindsWhenAvailable() async throws {
        let publishers = FakeSource(
            id: "publishers",
            isEnabled: true,
            result: .success([
                makeEvent(
                    id: "pub:3",
                    timestamp: "2026-03-18T12:00:00Z",
                    source: "Reuters",
                    newsSource: makeNewsSource(
                        displayName: "Reuters",
                        kind: .publisher,
                        identity: "reuters",
                        group: "reuters",
                        attribution: .direct
                    )
                ),
                makeEvent(
                    id: "pub:2",
                    timestamp: "2026-03-18T11:00:00Z",
                    source: "BBC News",
                    newsSource: makeNewsSource(
                        displayName: "BBC News",
                        kind: .publisher,
                        identity: "bbc-news",
                        group: "bbc-news",
                        attribution: .direct
                    )
                ),
                makeEvent(
                    id: "pub:1",
                    timestamp: "2026-03-18T10:00:00Z",
                    source: "Al Jazeera",
                    newsSource: makeNewsSource(
                        displayName: "Al Jazeera",
                        kind: .publisher,
                        identity: "al-jazeera",
                        group: "al-jazeera",
                        attribution: .direct
                    )
                )
            ])
        )
        let social = FakeSource(
            id: "social",
            isEnabled: true,
            result: .success([
                makeEvent(
                    id: "social:1",
                    timestamp: "2026-03-18T09:00:00Z",
                    source: "x:@alpha",
                    newsSource: makeNewsSource(
                        displayName: "x:@alpha",
                        kind: .social,
                        identity: "x:alpha",
                        group: "x",
                        attribution: .direct,
                        authorHandle: "@alpha"
                    )
                )
            ])
        )
        let aggregator = NewsSourceAggregator(
            sources: [publishers, social],
            sourceTimeout: .milliseconds(50),
            diversityPolicy: .init(maxSourceShare: 1.0, minDistinctKinds: 2, minDistinctRegions: 0)
        )

        let events = try await aggregator.fetchAll(limit: 3)
        let kinds = Set(events.compactMap { $0.newsSource?.kind })

        XCTAssertEqual(events.map(\.id), ["pub:3", "pub:2", "social:1"])
        XCTAssertEqual(kinds.count, 2)
        XCTAssertTrue(kinds.contains(.social))
    }

    func testAttributionFloorBackfillsDerivedWhenAvailable() async throws {
        let direct = FakeSource(
            id: "direct",
            isEnabled: true,
            result: .success([
                makeEvent(
                    id: "direct:3",
                    timestamp: "2026-03-18T12:00:00Z",
                    source: "Reuters",
                    newsSource: makeNewsSource(
                        displayName: "Reuters",
                        kind: .wire,
                        identity: "reuters",
                        group: "reuters",
                        attribution: .direct
                    )
                ),
                makeEvent(
                    id: "direct:2",
                    timestamp: "2026-03-18T11:00:00Z",
                    source: "BBC News",
                    newsSource: makeNewsSource(
                        displayName: "BBC News",
                        kind: .publisher,
                        identity: "bbc-news",
                        group: "bbc-news",
                        attribution: .direct
                    )
                ),
                makeEvent(
                    id: "direct:1",
                    timestamp: "2026-03-18T10:00:00Z",
                    source: "Al Jazeera",
                    newsSource: makeNewsSource(
                        displayName: "Al Jazeera",
                        kind: .publisher,
                        identity: "al-jazeera",
                        group: "al-jazeera",
                        attribution: .direct
                    )
                )
            ])
        )
        let derived = FakeSource(
            id: "derived",
            isEnabled: true,
            result: .success([
                makeEvent(
                    id: "derived:1",
                    timestamp: "2026-03-18T09:00:00Z",
                    source: "GDELT",
                    newsSource: makeNewsSource(
                        displayName: "GDELT",
                        kind: .aggregator,
                        identity: "gdelt:example.com",
                        group: "gdelt:example.com",
                        attribution: .derived
                    )
                )
            ])
        )
        let aggregator = NewsSourceAggregator(
            sources: [direct, derived],
            sourceTimeout: .milliseconds(50),
            diversityPolicy: .init(maxSourceShare: 1.0, maxDerivedShare: 1.0, minDistinctAttributions: 2, minDistinctRegions: 0)
        )

        let events = try await aggregator.fetchAll(limit: 3)
        let attributions = Set(events.compactMap { $0.newsSource?.attribution })

        XCTAssertEqual(events.map(\.id), ["direct:3", "direct:2", "derived:1"])
        XCTAssertEqual(attributions.count, 2)
        XCTAssertTrue(attributions.contains(.derived))
    }

    private func makeEvent(
        id: String,
        timestamp: String,
        source: String = "source",
        title: String = "Title",
        summary: String? = nil,
        url: String? = nil,
        newsSource: NewsSourceDescriptor? = nil
    ) -> CrisisEvent {
        CrisisEvent(
            id: id,
            title: title,
            summary: summary ?? "Summary \(id)",
            category: .conflict,
            level: .high,
            location: nil,
            timestamp: timestamp,
            source: source,
            sourceTier: .public,
            url: url,
            actor: nil,
            entities: nil,
            newsSource: newsSource
        )
    }

    private func makeNewsSource(
        displayName: String,
        kind: NewsSourceKind,
        identity: String,
        group: String,
        attribution: NewsSourceAttribution,
        authorHandle: String? = nil
    ) -> NewsSourceDescriptor {
        NewsSourceDescriptor(
            displayName: displayName,
            kind: kind,
            identity: identity,
            group: group,
            attribution: attribution,
            authorHandle: authorHandle
        )
    }
}

private enum MockError: Error {
    case failed
}

private final class FakeSource: NewsDataSource, @unchecked Sendable {
    let id: String
    let name: String
    let isEnabled: Bool

    private let result: Result<[CrisisEvent], Error>
    private let counter = FetchCounter()

    init(id: String, isEnabled: Bool, result: Result<[CrisisEvent], Error>) {
        self.id = id
        self.name = id
        self.isEnabled = isEnabled
        self.result = result
    }

    func fetch(limit: Int) async throws -> [CrisisEvent] {
        await counter.increment()

        switch result {
        case .success(let events):
            return Array(events.prefix(limit))
        case .failure(let error):
            throw error
        }
    }

    func fetchCount() async -> Int {
        await counter.snapshot()
    }
}

private final class HangingSource: NewsDataSource, @unchecked Sendable {
    let id: String
    let name: String
    let isEnabled = true

    private let counter = FetchCounter()

    init(id: String) {
        self.id = id
        self.name = id
    }

    func fetch(limit: Int) async throws -> [CrisisEvent] {
        await counter.increment()

        do {
            try await Task.sleep(for: .seconds(1))
            return []
        } catch {
            throw error
        }
    }

    func fetchCount() async -> Int {
        await counter.snapshot()
    }
}

private final class StubbornSource: NewsDataSource, @unchecked Sendable {
    let id: String
    let name: String
    let isEnabled = true

    init(id: String) {
        self.id = id
        self.name = id
    }

    func fetch(limit: Int) async throws -> [CrisisEvent] {
        await withCheckedContinuation { continuation in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.2) {
                continuation.resume(returning: ())
            }
        }

        return [
            CrisisEvent(
                id: "stubborn:1",
                title: "Late event",
                summary: "Ignored cancellation",
                category: .statement,
                level: .info,
                location: nil,
                timestamp: "2026-03-18T12:00:00Z",
                source: "stubborn",
                sourceTier: .public,
                url: nil,
                actor: nil,
                entities: nil
            )
        ]
    }
}

private actor FetchCounter {
    private var value = 0

    func increment() {
        value += 1
    }

    func snapshot() -> Int {
        value
    }
}
