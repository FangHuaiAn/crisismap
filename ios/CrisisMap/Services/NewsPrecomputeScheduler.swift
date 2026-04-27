import Foundation
import SwiftData

@MainActor
final class NewsPrecomputeScheduler {
    private let modelContext: ModelContext
    private let calendar: Calendar

    init(modelContext: ModelContext, calendar: Calendar = .current) {
        self.modelContext = modelContext
        self.calendar = calendar
    }

    func nextRunDate(after date: Date = .now, config: NewsScoringConfig = .default) -> Date {
        var components = DateComponents()
        components.hour = config.precomputeHour
        components.minute = config.precomputeMinute
        components.second = 0

        guard let candidate = calendar.nextDate(
            after: date,
            matching: components,
            matchingPolicy: .nextTime,
            repeatedTimePolicy: .first,
            direction: .forward
        ) else {
            return date
        }

        if candidate <= date {
            return calendar.date(byAdding: .day, value: 1, to: candidate) ?? candidate
        }

        return candidate
    }

    func persistSnapshot(scores: [MentionClusterScore], asOf: Date, halfLifeDays: Double) throws {
        let encoder = JSONEncoder()
        let payload = try encoder.encode(scores)
        let key = CachedMentionSnapshot.makeKey(asOf: asOf)

        let descriptor = FetchDescriptor<CachedMentionSnapshot>(
            predicate: #Predicate { $0.key == key }
        )

        if let existing = try modelContext.fetch(descriptor).first {
            existing.asOf = asOf
            existing.halfLifeDays = halfLifeDays
            existing.payload = payload
            existing.generatedAt = .now
        } else {
            modelContext.insert(
                CachedMentionSnapshot(
                    asOf: asOf,
                    halfLifeDays: halfLifeDays,
                    payload: payload
                )
            )
        }

        try modelContext.save()
    }

    func loadSnapshot(asOf: Date) throws -> MentionSnapshot? {
        let key = CachedMentionSnapshot.makeKey(asOf: asOf)
        let descriptor = FetchDescriptor<CachedMentionSnapshot>(
            predicate: #Predicate { $0.key == key }
        )

        guard let cached = try modelContext.fetch(descriptor).first else {
            return nil
        }

        let clusters = try JSONDecoder().decode([MentionClusterScore].self, from: cached.payload)
        return MentionSnapshot(asOf: cached.asOf, halfLifeDays: cached.halfLifeDays, clusters: clusters)
    }

    func isSnapshotStale(_ snapshot: MentionSnapshot, requiredAsOf: Date) -> Bool {
        snapshot.asOf < requiredAsOf
    }
}
