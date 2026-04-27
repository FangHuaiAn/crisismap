import Foundation
import SwiftData

@MainActor
final class NewsBatchCache {
    private let modelContext: ModelContext
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func save(events: [CrisisEvent], fetchedAt: Date = .now) throws {
        let payload = try encoder.encode(events)
        let existing = try fetchCachedBatch()

        if let existing {
            existing.fetchedAt = fetchedAt
            existing.payload = payload
        } else {
            modelContext.insert(
                CachedNewsBatch(
                    key: CachedNewsBatch.defaultKey,
                    fetchedAt: fetchedAt,
                    payload: payload
                )
            )
        }

        try modelContext.save()
    }

    func load() throws -> (events: [CrisisEvent], fetchedAt: Date)? {
        guard let cached = try fetchCachedBatch() else {
            return nil
        }

        do {
            let events = try decoder.decode([CrisisEvent].self, from: cached.payload)
            return (events: events, fetchedAt: cached.fetchedAt)
        } catch {
            modelContext.delete(cached)
            try modelContext.save()
            return nil
        }
    }

    func clear() throws {
        if let batch = try fetchCachedBatch() {
            modelContext.delete(batch)
            try modelContext.save()
        }
    }

    private func fetchCachedBatch() throws -> CachedNewsBatch? {
        let cacheKey = CachedNewsBatch.defaultKey
        var descriptor = FetchDescriptor<CachedNewsBatch>(
            predicate: #Predicate { $0.key == cacheKey }
        )
        descriptor.fetchLimit = 1
        return try modelContext.fetch(descriptor).first
    }
}
