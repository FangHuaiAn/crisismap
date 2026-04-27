import XCTest
@testable import CrisisMap

@MainActor
final class EventsViewModelTests: XCTestCase {
    func testUnlocatedEventsAreAvailableAsRegionFallback() async throws {
        let viewModel = EventsViewModel(
            eventFetcher: StubEventFetcher(events: [
                makeEvent(
                    id: "middle-east:1",
                    title: "Middle East shipping alerts rise near Red Sea",
                    summary: "Regional military activity remains elevated around Yemen."
                )
            ])
        )

        await viewModel.refresh()

        XCTAssertTrue(viewModel.eventsWithLocation.isEmpty)
        let fallback = try XCTUnwrap(viewModel.regionFallbacks.first)
        XCTAssertEqual(fallback.region, .middleEast)
        XCTAssertEqual(fallback.events.map(\.id), ["middle-east:1"])
    }

    private func makeEvent(
        id: String,
        title: String,
        summary: String,
        location: Location? = nil
    ) -> CrisisEvent {
        CrisisEvent(
            id: id,
            title: title,
            summary: summary,
            category: .conflict,
            level: .high,
            location: location,
            timestamp: "2026-03-18T12:00:00Z",
            source: "Stub",
            sourceTier: .public,
            url: nil,
            actor: nil,
            entities: nil
        )
    }
}

private struct StubEventFetcher: EventFetching {
    let events: [CrisisEvent]

    func fetchEvents(locale: String) async throws -> [CrisisEvent] {
        events
    }
}
