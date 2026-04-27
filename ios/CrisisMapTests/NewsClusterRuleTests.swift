import XCTest
@testable import CrisisMap

final class NewsClusterRuleTests: XCTestCase {
    func testRuleSetDecodesFromJSON() throws {
        let json = """
        {
          \"version\": \"1.0\",
          \"rules\": [
            {
              \"clusterId\": \"test\",
              \"label\": \"Test\",
              \"priority\": 10,
              \"keywordsAny\": [\"alpha\"],
              \"regions\": [\"europe\"],
              \"topics\": [\"demo\"]
            }
          ]
        }
        """

        let decoded = try JSONDecoder().decode(NewsClusterRuleSet.self, from: Data(json.utf8))

        XCTAssertEqual(decoded.version, "1.0")
        XCTAssertEqual(decoded.rules.count, 1)
        XCTAssertEqual(decoded.rules[0].clusterId, "test")
        XCTAssertEqual(decoded.rules[0].keywordsAll, [])
    }

    func testPrioritizedSortsByPriorityThenClusterId() {
        let a = NewsClusterRule(
            clusterId: "b-cluster",
            label: "B",
            priority: 10,
            keywordsAny: ["x"],
            keywordsAll: [],
            regions: [.europe],
            topics: ["x"]
        )
        let b = NewsClusterRule(
            clusterId: "a-cluster",
            label: "A",
            priority: 10,
            keywordsAny: ["x"],
            keywordsAll: [],
            regions: [.europe],
            topics: ["x"]
        )
        let c = NewsClusterRule(
            clusterId: "c-cluster",
            label: "C",
            priority: 5,
            keywordsAny: ["x"],
            keywordsAll: [],
            regions: [.europe],
            topics: ["x"]
        )

        let ordered = NewsClusterRule.prioritized([a, b, c])

        XCTAssertEqual(ordered.map(\.clusterId), ["c-cluster", "a-cluster", "b-cluster"])
    }

    func testRuleKeepsRegionAndTopicAssignments() {
        let rule = NewsClusterRule(
            clusterId: "us-china",
            label: "US China",
            priority: 30,
            keywordsAny: ["washington"],
            keywordsAll: [],
            regions: [.americas, .eastAsia],
            topics: ["geoeconomics", "technology"]
        )

        XCTAssertEqual(rule.regions, [.americas, .eastAsia])
        XCTAssertEqual(rule.topics, ["geoeconomics", "technology"])
    }
}
