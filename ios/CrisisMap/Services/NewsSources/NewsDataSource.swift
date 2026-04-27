import Foundation

/// News sources return normalized `CrisisEvent` values and should honor the requested limit.
protocol NewsDataSource: Sendable {
    var id: String { get }
    var name: String { get }
    var isEnabled: Bool { get }
    func fetch(limit: Int) async throws -> [CrisisEvent]
}

struct FixtureNewsSource: NewsDataSource {
    let id = "fixture"
    let name = "Fixture"
    let isEnabled = true

    func fetch(limit: Int) async throws -> [CrisisEvent] {
        Array(Self.events.prefix(max(0, limit)))
    }

    private static let events: [CrisisEvent] = [
        fixtureEvent(
            id: "fixture-east-asia",
            title: "Taiwan Strait patrols remain elevated",
            summary: "Regional reporting continues to track air and maritime activity around Taiwan.",
            category: .military,
            level: .medium
        ),
        fixtureEvent(
            id: "fixture-middle-east",
            title: "Middle East ceasefire diplomacy faces pressure",
            summary: "Diplomatic channels remain active as regional actors weigh security guarantees.",
            category: .diplomatic,
            level: .medium
        ),
        fixtureEvent(
            id: "fixture-europe",
            title: "NATO governments review Ukraine support timelines",
            summary: "European security planning remains focused on Russia and Ukraine.",
            category: .military,
            level: .medium
        )
    ]

    private static func fixtureEvent(
        id: String,
        title: String,
        summary: String,
        category: EventCategory,
        level: ThreatLevel
    ) -> CrisisEvent {
        CrisisEvent(
            id: id,
            title: title,
            summary: summary,
            category: category,
            level: level,
            location: nil,
            timestamp: "2026-04-26T00:00:00Z",
            source: "Fixture",
            sourceTier: .public,
            url: nil,
            actor: nil,
            entities: nil,
            newsSource: NewsSourceDescriptor(
                displayName: "Fixture",
                kind: .aggregator,
                identity: id,
                group: "built-in",
                attribution: .derived
            )
        )
    }
}
