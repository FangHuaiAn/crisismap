import XCTest
@testable import CrisisMap

final class NewsClusteringEngineTests: XCTestCase {
    func testFirstMatchWinsByPriority() {
        let lowPriority = NewsClusterRule(
            clusterId: "low",
            label: "Low",
            priority: 20,
            keywordsAny: ["ukraine"],
            keywordsAll: [],
            regions: [.europe],
            topics: ["war"]
        )
        let highPriority = NewsClusterRule(
            clusterId: "high",
            label: "High",
            priority: 10,
            keywordsAny: ["ukraine"],
            keywordsAll: [],
            regions: [.europe],
            topics: ["war"]
        )
        let engine = NewsClusteringEngine(rules: [lowPriority, highPriority])

        let clustered = engine.cluster(event: makeEvent(title: "Ukraine front update", summary: "New strike reported"))

        XCTAssertEqual(clustered.clusterId, "high")
    }

    func testFallsBackToUnclassifiedWhenNoRuleMatches() {
        let engine = NewsClusteringEngine(rules: [])

        let clustered = engine.cluster(event: makeEvent(title: "Unknown issue", summary: "No known keyword"))

        XCTAssertEqual(clustered.clusterId, "unclassified")
        XCTAssertEqual(clustered.clusterLabel, "Unclassified")
    }

    func testMultiRegionAssignmentComesFromRule() {
        let rule = NewsClusterRule(
            clusterId: "multi",
            label: "Multi",
            priority: 10,
            keywordsAny: ["sanctions"],
            keywordsAll: ["beijing", "washington"],
            regions: [.americas, .eastAsia],
            topics: ["geoeconomics"]
        )
        let engine = NewsClusteringEngine(rules: [rule])

        let clustered = engine.cluster(event: makeEvent(title: "Washington expands sanctions", summary: "Beijing response expected"))

        XCTAssertEqual(clustered.regions, [.americas, .eastAsia])
    }

    private func makeEvent(title: String, summary: String, source: String = "Test Source") -> CrisisEvent {
        CrisisEvent(
            id: UUID().uuidString,
            title: title,
            summary: summary,
            category: .conflict,
            level: .high,
            location: nil,
            timestamp: "2026-03-18T08:00:00Z",
            source: source,
            sourceTier: .public,
            url: nil,
            actor: nil,
            entities: nil
        )
    }
}
