import Foundation
import SwiftData

@MainActor
final class MentionStore {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func ingest(clusteredEvents: [ClusteredEvent]) throws {
        for clusteredEvent in clusteredEvents {
            try upsert(
                source: Self.identity(for: clusteredEvent.event),
                clusterId: clusteredEvent.clusterId,
                eventId: clusteredEvent.event.id,
                sourceAttribution: clusteredEvent.event.newsSource?.attribution,
                seenAt: clusteredEvent.event.date
            )
        }
    }

    func upsert(
        source: String,
        clusterId: String,
        eventId: String?,
        sourceAttribution: NewsSourceAttribution? = nil,
        seenAt: Date = .now
    ) throws {
        let mentionKey = Self.makeKey(source: source, clusterId: clusterId)
        let descriptor = FetchDescriptor<CachedMention>(
            predicate: #Predicate { $0.key == mentionKey }
        )

        if let existing = try modelContext.fetch(descriptor).first {
            if seenAt < existing.firstSeenAt {
                existing.firstSeenAt = seenAt
            }
            if seenAt > existing.lastSeenAt {
                existing.lastSeenAt = seenAt
            }
            if let eventId {
                existing.sampleEventId = eventId
            }
            if let sourceAttribution {
                existing.sourceAttribution = sourceAttribution
            }
        } else {
            let mention = CachedMention(
                key: mentionKey,
                source: source,
                clusterId: clusterId,
                firstSeenAt: seenAt,
                lastSeenAt: seenAt,
                sampleEventId: eventId,
                sourceAttribution: sourceAttribution
            )
            modelContext.insert(mention)
        }

        try modelContext.save()
    }

    func fetchAll() throws -> [CachedMention] {
        var descriptor = FetchDescriptor<CachedMention>()
        descriptor.sortBy = [
            SortDescriptor(\.clusterId),
            SortDescriptor(\.source)
        ]
        return try modelContext.fetch(descriptor)
    }

    func fetchOne(source: String, clusterId: String) throws -> CachedMention? {
        let mentionKey = Self.makeKey(source: source, clusterId: clusterId)
        let descriptor = FetchDescriptor<CachedMention>(
            predicate: #Predicate { $0.key == mentionKey }
        )
        return try modelContext.fetch(descriptor).first
    }

    nonisolated static func makeKey(source: String, clusterId: String) -> String {
        let normalizedSource = source
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        return "\(normalizedSource)::\(clusterId.lowercased())"
    }

    nonisolated static func identity(for event: CrisisEvent) -> String {
        let identity = event.newsSource?.identity ?? event.source
        return identity.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
