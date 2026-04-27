import XCTest
@testable import CrisisMap

final class NewsSourcePresentationTests: XCTestCase {
    func testBadgeTextsForDirectWireSource() {
        let event = makeEvent(
            source: "Reuters",
            newsSource: NewsSourceDescriptor(
                displayName: "Reuters",
                kind: .wire,
                identity: "reuters",
                group: "reuters",
                attribution: .direct,
                originalOutlet: "Reuters"
            )
        )

        XCTAssertEqual(NewsSourcePresentation.attributionText(for: event), "Direct")
        XCTAssertEqual(NewsSourcePresentation.kindText(for: event), "Wire")
        XCTAssertNil(NewsSourcePresentation.outletSubtitle(for: event))
    }

    func testBadgeTextsAndDomainFallbackForDerivedAggregatorSource() {
        let event = makeEvent(
            source: "GDELT",
            newsSource: NewsSourceDescriptor(
                displayName: "GDELT",
                kind: .aggregator,
                identity: "gdelt:example.com",
                group: "gdelt:example.com",
                attribution: .derived,
                domain: "example.com"
            )
        )

        XCTAssertEqual(NewsSourcePresentation.attributionText(for: event), "Derived")
        XCTAssertEqual(NewsSourcePresentation.kindText(for: event), "Aggregator")
        XCTAssertEqual(NewsSourcePresentation.outletSubtitle(for: event), "example.com")
    }

    func testOutletSubtitleSuppressesRepeatedDisplayNameAfterNormalization() {
        let event = makeEvent(
            source: "Reuters",
            newsSource: NewsSourceDescriptor(
                displayName: "Reuters",
                kind: .wire,
                identity: "reuters",
                group: "reuters",
                attribution: .direct,
                originalOutlet: "  Reuters  "
            )
        )

        XCTAssertNil(NewsSourcePresentation.outletSubtitle(for: event))
    }

    private func makeEvent(source: String, newsSource: NewsSourceDescriptor?) -> CrisisEvent {
        CrisisEvent(
            id: UUID().uuidString,
            title: "Title",
            summary: "Summary",
            category: .conflict,
            level: .high,
            location: nil,
            timestamp: "2026-03-18T08:00:00Z",
            source: source,
            sourceTier: .public,
            url: nil,
            actor: nil,
            entities: nil,
            newsSource: newsSource
        )
    }
}
