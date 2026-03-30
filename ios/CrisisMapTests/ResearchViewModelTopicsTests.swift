import XCTest
@testable import CrisisMap

@MainActor
final class ResearchViewModelTopicsTests: XCTestCase {
    func testTopicsFallbackToArticleDerivedWhenCatalogIsUnavailable() {
        let vm = ResearchViewModel()
        vm.articles = [
            makeArticle(id: "a1", category: "china_indopacific", topics: ["AI", "China"]),
            makeArticle(id: "a2", category: "china_indopacific", topics: ["AI"])
        ]

        vm.applyTopicCatalog([])
        let topics = vm.topicsForRegion(.all)

        XCTAssertEqual(topics.map(\.topic), ["AI", "China"])
        XCTAssertEqual(topics.map(\.count), [2, 1])
    }

    func testTopicsUseRemoteCatalogAndHideZeroCountTopics() {
        let vm = ResearchViewModel()
        vm.articles = [
            makeArticle(id: "a1", category: "china_indopacific", topics: ["AI", "China"]),
            makeArticle(id: "a2", category: "china_indopacific", topics: ["AI", "Trade"])
        ]

        vm.applyTopicCatalog(["China", "Taiwan", "AI"])
        let topics = vm.topicsForRegion(.all)

        XCTAssertEqual(topics.map(\.topic), ["AI", "China"])
        XCTAssertEqual(topics.map(\.count), [2, 1])
        XCTAssertFalse(topics.contains(where: { $0.topic == "Taiwan" }))
        XCTAssertFalse(topics.contains(where: { $0.topic == "Trade" }))
    }

    func testAPIBaseURLPrefersEnvironmentOverride() {
        let resolved = APIClient.resolveBaseURL(
            environment: ["CRISISMAP_API_BASE_URL": "https://api.example.com"],
            infoDictionary: ["API_BASE_URL": "https://ignored.example.com"]
        )

        XCTAssertEqual(resolved.absoluteString, "https://api.example.com")
    }

    func testAPIBaseURLFallsBackToInfoPlistValue() {
        let resolved = APIClient.resolveBaseURL(
            environment: [:],
            infoDictionary: ["API_BASE_URL": "https://prod.example.com"]
        )

        XCTAssertEqual(resolved.absoluteString, "https://prod.example.com")
    }

    func testAPIBaseURLFallsBackToLocalhostForInvalidValues() {
        let resolved = APIClient.resolveBaseURL(
            environment: ["CRISISMAP_API_BASE_URL": "not-a-url"],
            infoDictionary: ["API_BASE_URL": "ftp://invalid-scheme.example.com"]
        )

        XCTAssertEqual(resolved.absoluteString, "http://localhost:3000")
    }

    private func makeArticle(id: String, category: String, topics: [String]) -> ThinkTankArticle {
        ThinkTankArticle(
            id: id,
            thinkTank: "RAND",
            title: "Title \(id)",
            url: "https://example.com/\(id)",
            date: "2026-03-01",
            summary: "Summary",
            category: category,
            status: "reviewed",
            topics: topics
        )
    }
}
