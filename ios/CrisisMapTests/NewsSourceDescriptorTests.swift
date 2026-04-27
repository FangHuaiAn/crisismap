import XCTest
@testable import CrisisMap

final class NewsSourceDescriptorTests: XCTestCase {
    func testCrisisEventKeepsDisplaySourceInSyncWithStructuredNewsSource() {
        let descriptor = NewsSourceDescriptor(
            displayName: "Reuters",
            kind: .wire,
            identity: "reuters",
            group: "reuters",
            attribution: .direct
        )

        let event = CrisisEvent(
            id: "event-1",
            title: "Title",
            summary: "Summary",
            category: .conflict,
            level: .high,
            location: nil,
            timestamp: "2026-04-13T00:00:00Z",
            source: "Reuters",
            sourceTier: .public,
            url: nil,
            actor: nil,
            entities: nil,
            newsSource: descriptor
        )

        XCTAssertEqual(event.source, "Reuters")
        XCTAssertEqual(event.newsSource?.identity, "reuters")
        XCTAssertEqual(event.newsSource?.displayName, event.source)
    }
}
