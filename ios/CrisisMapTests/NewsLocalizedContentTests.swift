import XCTest
@testable import CrisisMap

final class NewsLocalizedContentTests: XCTestCase {
    func testDisplayFallsBackToOriginalTextWhenLocalizedContentIsMissing() {
        let event = makeEvent(title: "Original title", summary: "Original summary")
        let display = NewsLocalizedEventDisplay(event: event, localizedContent: nil)

        XCTAssertEqual(display.displayTitle, "Original title")
        XCTAssertEqual(display.displaySummary, "Original summary")
        XCTAssertFalse(display.hasLocalizedContent)
    }

    func testDisplayUsesLocalizedTitleAndSummaryWhenAvailable() {
        let event = makeEvent(title: "Original title", summary: "Original summary")
        let content = makeLocalizedContent(title: "中文標題", summary: "中文摘要", event: event)
        let display = NewsLocalizedEventDisplay(event: event, localizedContent: content)

        XCTAssertEqual(display.displayTitle, "中文標題")
        XCTAssertEqual(display.displaySummary, "中文摘要")
        XCTAssertTrue(display.hasLocalizedContent)
    }

    func testDisplayFallsBackPerFieldWhenLocalizedTextIsEmpty() {
        let event = makeEvent(title: "Original title", summary: "Original summary")
        let content = makeLocalizedContent(title: "中文標題", summary: "", event: event)
        let display = NewsLocalizedEventDisplay(event: event, localizedContent: content)

        XCTAssertEqual(display.displayTitle, "中文標題")
        XCTAssertEqual(display.displaySummary, "Original summary")
    }

    func testCacheKeyChangesWhenContentOrLocaleChanges() {
        let base = makeEvent(id: "event-1", title: "Title", summary: "Summary")
        let changedTitle = makeEvent(id: "event-1", title: "Updated title", summary: "Summary")
        let changedSummary = makeEvent(id: "event-1", title: "Title", summary: "Updated summary")

        let baseKey = NewsLocalizedContent.cacheKey(event: base, localeIdentifier: "zh-Hant-TW")

        XCTAssertNotEqual(baseKey, NewsLocalizedContent.cacheKey(event: changedTitle, localeIdentifier: "zh-Hant-TW"))
        XCTAssertNotEqual(baseKey, NewsLocalizedContent.cacheKey(event: changedSummary, localeIdentifier: "zh-Hant-TW"))
        XCTAssertNotEqual(baseKey, NewsLocalizedContent.cacheKey(event: base, localeIdentifier: "ja"))
    }

    private func makeLocalizedContent(title: String, summary: String, event: CrisisEvent) -> NewsLocalizedContent {
        NewsLocalizedContent(
            eventId: event.id,
            localeIdentifier: "zh-Hant-TW",
            sourceTitleHash: NewsLocalizedContent.contentHash(event.title),
            sourceSummaryHash: NewsLocalizedContent.contentHash(event.summary),
            title: title,
            summary: summary,
            provider: "test",
            translatedAt: Date(timeIntervalSince1970: 1_777_777_777)
        )
    }

    private func makeEvent(
        id: String = "event-1",
        title: String,
        summary: String
    ) -> CrisisEvent {
        CrisisEvent(
            id: id,
            title: title,
            summary: summary,
            category: .conflict,
            level: .high,
            location: nil,
            timestamp: "2026-05-07T00:00:00Z",
            source: "Reuters",
            sourceTier: .public,
            url: nil,
            actor: nil,
            entities: nil
        )
    }
}
