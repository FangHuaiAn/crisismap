import XCTest
@testable import CrisisMap

final class ResearchRelevanceTests: XCTestCase {
    func testRelatedResearchUsesRegionAndActorTopics() {
        let result = RelatedResearch.match(
            eventRegion: .africa,
            entities: ["Russia", "Sahel"],
            articles: [
                article(id: "africa", category: "africa", topics: ["Sahel"]),
                article(id: "europe", category: "europe", topics: ["NATO"])
            ]
        )

        XCTAssertEqual(result.map(\.id), ["africa"])
    }

    func testRelatedResearchForEventFallsBackToRegionText() {
        let result = RelatedResearch.match(
            event: event(
                title: "Red Sea shipping disrupted by Houthi attacks",
                summary: "Commercial shipping remains exposed near Yemen.",
                actor: "Houthi",
                entities: ["Houthi"]
            ),
            articles: [article(id: "middle-east", category: "middle_east", topics: ["Houthi"])]
        )

        XCTAssertEqual(result.map(\.id), ["middle-east"])
    }

    private func article(
        id: String,
        category: String,
        topics: [String]
    ) -> ThinkTankArticle {
        ThinkTankArticle(
            id: id,
            thinkTank: "RAND",
            title: "Report \(id)",
            url: "https://example.com/\(id)",
            date: "2026-04-01",
            summary: "Summary",
            category: category,
            status: "reviewed",
            topics: topics
        )
    }

    private func event(
        title: String,
        summary: String,
        actor: String,
        entities: [String]
    ) -> CrisisEvent {
        CrisisEvent(
            id: "event",
            title: title,
            summary: summary,
            category: .military,
            level: .high,
            location: nil,
            timestamp: "2026-04-26T00:00:00Z",
            source: "Fixture",
            sourceTier: .public,
            url: nil,
            actor: actor,
            entities: entities
        )
    }
}
