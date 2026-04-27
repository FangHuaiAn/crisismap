import SwiftData
import XCTest
@testable import CrisisMap

@MainActor
final class NewsPrecomputeSchedulerTests: XCTestCase {
    func testNextRunDateIsLocalNextMidnight() throws {
        let scheduler = try makeScheduler(timeZone: 0)
        let now = Date(timeIntervalSince1970: 1_742_295_300) // 2025-03-19 10:15:00 UTC
        let config = NewsScoringConfig(halfLifeDays: 180, precomputeHour: 0, precomputeMinute: 0)

        let next = scheduler.nextRunDate(after: now, config: config)

        XCTAssertEqual(next.timeIntervalSince1970, 1_742_342_400, accuracy: 0.1) // 2025-03-20 00:00:00 UTC
    }

    func testSnapshotMetadataPersists() throws {
        let scheduler = try makeScheduler(timeZone: 0)
        let asOf = Date(timeIntervalSince1970: 1_742_344_000)
        let scores = [
            MentionClusterScore(
                clusterId: "russia-ukraine-war",
                label: "Russia-Ukraine War",
                score: 2.5,
                sourceCount: 3,
                lastMentionAt: asOf,
                regions: [.europe],
                topics: ["war"]
            )
        ]

        try scheduler.persistSnapshot(scores: scores, asOf: asOf, halfLifeDays: 180)
        let loaded = try scheduler.loadSnapshot(asOf: asOf)

        XCTAssertNotNil(loaded)
        XCTAssertEqual(loaded?.asOf, asOf)
        XCTAssertEqual(loaded?.halfLifeDays, 180)
        XCTAssertEqual(loaded?.clusters.count, 1)
        XCTAssertEqual(loaded?.clusters.first?.clusterId, "russia-ukraine-war")
    }

    func testStaleSnapshotDetection() throws {
        let scheduler = try makeScheduler(timeZone: 0)
        let old = MentionSnapshot(
            asOf: Date(timeIntervalSince1970: 1_742_257_600),
            halfLifeDays: 180,
            clusters: []
        )
        let fresh = MentionSnapshot(
            asOf: Date(timeIntervalSince1970: 1_742_344_000),
            halfLifeDays: 180,
            clusters: []
        )
        let required = Date(timeIntervalSince1970: 1_742_344_000)

        XCTAssertTrue(scheduler.isSnapshotStale(old, requiredAsOf: required))
        XCTAssertFalse(scheduler.isSnapshotStale(fresh, requiredAsOf: required))
    }

    private func makeScheduler(timeZone: Int) throws -> NewsPrecomputeScheduler {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: CachedMentionSnapshot.self, configurations: config)
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: timeZone)!
        return NewsPrecomputeScheduler(modelContext: ModelContext(container), calendar: calendar)
    }
}
