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
        XCTAssertEqual(
            NewsSourcePresentation.attributionText(for: event, locale: Locale(identifier: "zh-Hant-TW")),
            "直接來源"
        )
        XCTAssertEqual(
            NewsSourcePresentation.kindText(for: event, locale: Locale(identifier: "zh-Hant-TW")),
            "通訊社"
        )
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
        XCTAssertEqual(
            NewsSourcePresentation.attributionText(for: event, locale: Locale(identifier: "zh-Hant-TW")),
            "轉載彙整"
        )
        XCTAssertEqual(
            NewsSourcePresentation.kindText(for: event, locale: Locale(identifier: "zh-Hant-TW")),
            "聚合器"
        )
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
