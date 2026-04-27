import SwiftData
import XCTest
@testable import CrisisMap

@MainActor
final class MentionStoreTests: XCTestCase {
    func testFirstInsertCreatesMention() throws {
        let store = try makeStore()
        let event = makeClusteredEvent(source: "Reuters", clusterId: "russia-ukraine-war")

        try store.ingest(clusteredEvents: [event])
        let mentions = try store.fetchAll()

        XCTAssertEqual(mentions.count, 1)
        XCTAssertEqual(mentions.first?.clusterId, "russia-ukraine-war")
        XCTAssertEqual(mentions.first?.source, "Reuters")
    }

    func testRepeatedSameSourceAndClusterDoesNotIncreaseCount() throws {
        let store = try makeStore()
        let eventA = makeClusteredEvent(source: "AP", clusterId: "red-sea-shipping")
        let eventB = makeClusteredEvent(source: "AP", clusterId: "red-sea-shipping")

        try store.ingest(clusteredEvents: [eventA])
        try store.ingest(clusteredEvents: [eventB])

        XCTAssertEqual(try store.fetchAll().count, 1)
    }

    func testRepeatedKeyUpdatesLastSeenAt() throws {
        let store = try makeStore()
        let old = Date(timeIntervalSince1970: 1_000)
        let new = Date(timeIntervalSince1970: 10_000)

        try store.upsert(source: "BBC", clusterId: "taiwan-strait-tensions", eventId: "e-1", seenAt: old)
        try store.upsert(source: "BBC", clusterId: "taiwan-strait-tensions", eventId: "e-2", seenAt: new)

        let mention = try XCTUnwrap(store.fetchOne(source: "BBC", clusterId: "taiwan-strait-tensions"))
        XCTAssertEqual(mention.firstSeenAt, old)
        XCTAssertEqual(mention.lastSeenAt, new)
        XCTAssertEqual(mention.sampleEventId, "e-2")
    }

    func testIngestUsesStructuredSourceIdentityWhenAvailable() throws {
        let store = try makeStore()
        let event = makeClusteredEvent(
            source: "Reuters",
            clusterId: "russia-ukraine-war",
            newsSource: NewsSourceDescriptor(
                displayName: "Reuters",
                kind: .wire,
                identity: "reuters",
                group: "reuters",
                attribution: .direct
            )
        )

        try store.ingest(clusteredEvents: [event])

        let mention = try XCTUnwrap(store.fetchOne(source: "reuters", clusterId: "russia-ukraine-war"))
        XCTAssertEqual(mention.source, "reuters")
        XCTAssertEqual(mention.sourceAttribution, .direct)
    }

    private func makeStore() throws -> MentionStore {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: CachedMention.self, configurations: config)
        let context = ModelContext(container)
        return MentionStore(modelContext: context)
    }

    private func makeClusteredEvent(
        source: String,
        clusterId: String,
        newsSource: NewsSourceDescriptor? = nil
    ) -> ClusteredEvent {
        let event = CrisisEvent(
            id: UUID().uuidString,
            title: "Title",
            summary: "Summary",
            category: .conflict,
            level: .high,
            location: nil,
            timestamp: "2026-03-18T08:00:00Z",
            source: source,
            sourceTier: .public,
            url: nil,
            actor: nil,
            entities: nil,
            newsSource: newsSource
        )

        return ClusteredEvent(
            event: event,
            clusterId: clusterId,
            clusterLabel: "Label",
            regions: [.europe],
            topics: ["war"]
        )
    }
}
