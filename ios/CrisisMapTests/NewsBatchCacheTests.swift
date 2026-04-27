import SwiftData
import XCTest
@testable import CrisisMap

@MainActor
final class NewsBatchCacheTests: XCTestCase {
    func testRoundTripsAcrossFreshModelContext() throws {
        let fixture = try makeFixture()
        let referenceDate = Date(timeIntervalSince1970: 1_742_295_300)
        let events = [makeEvent(id: "rss:1"), makeEvent(id: "gdelt:1")]

        try fixture.cache.save(events: events, fetchedAt: referenceDate)
        let freshCache = NewsBatchCache(modelContext: ModelContext(fixture.container))
        let restored = try XCTUnwrap(freshCache.load())

        XCTAssertEqual(restored.events.map(\.id), ["rss:1", "gdelt:1"])
        XCTAssertEqual(restored.fetchedAt, referenceDate)
    }

    func testSecondSaveOverwritesFirstBatch() throws {
        let fixture = try makeFixture()
        let firstDate = Date(timeIntervalSince1970: 1_742_295_300)
        let secondDate = Date(timeIntervalSince1970: 1_742_381_700)

        try fixture.cache.save(events: [makeEvent(id: "rss:1")], fetchedAt: firstDate)
        try fixture.cache.save(events: [makeEvent(id: "gdelt:1"), makeEvent(id: "x:1")], fetchedAt: secondDate)

        let freshCache = NewsBatchCache(modelContext: ModelContext(fixture.container))
        let restored = try XCTUnwrap(freshCache.load())

        XCTAssertEqual(restored.events.map(\.id), ["gdelt:1", "x:1"])
        XCTAssertEqual(restored.fetchedAt, secondDate)
    }

    func testClearEmptiesCache() throws {
        let fixture = try makeFixture()
        try fixture.cache.save(events: [makeEvent(id: "rss:1")], fetchedAt: .now)

        try fixture.cache.clear()

        let freshCache = NewsBatchCache(modelContext: ModelContext(fixture.container))
        XCTAssertNil(try freshCache.load())
        XCTAssertEqual(try cachedRowCount(in: ModelContext(fixture.container)), 0)
    }

    func testCorruptPayloadReturnsNilAndPurgesBadRow() throws {
        let fixture = try makeFixture()
        let badBatch = CachedNewsBatch(
            key: CachedNewsBatch.defaultKey,
            fetchedAt: .now,
            payload: Data([0x00, 0xFF, 0x10])
        )
        fixture.context.insert(badBatch)
        try fixture.context.save()

        let cache = NewsBatchCache(modelContext: ModelContext(fixture.container))
        XCTAssertNil(try cache.load())
        XCTAssertEqual(try cachedRowCount(in: ModelContext(fixture.container)), 0)
    }

    private func makeFixture() throws -> (container: ModelContainer, context: ModelContext, cache: NewsBatchCache) {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: CachedNewsBatch.self, configurations: config)
        let context = ModelContext(container)
        return (container, context, NewsBatchCache(modelContext: context))
    }

    private func cachedRowCount(in context: ModelContext) throws -> Int {
        try context.fetch(FetchDescriptor<CachedNewsBatch>()).count
    }

    private func makeEvent(id: String) -> CrisisEvent {
        CrisisEvent(
            id: id,
            title: "Title \(id)",
            summary: "Summary \(id)",
            category: .conflict,
            level: .high,
            location: nil,
            timestamp: "2026-03-18T08:00:00Z",
            source: "Reuters",
            sourceTier: .public,
            url: nil,
            actor: nil,
            entities: nil
        )
    }
}
