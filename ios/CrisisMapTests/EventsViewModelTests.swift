import XCTest
@testable import CrisisMap

@MainActor
final class EventsViewModelTests: XCTestCase {
    func testNewsBackedMapFetcherFallsBackToBuiltInEventsWhenLiveProviderIsEmpty() async throws {
        let fetcher = NewsBackedEventFetcher(
            eventProvider: FallbackNewsEventProvider(
                primary: EmptyNewsEventProvider(),
                fallback: NewsSourceAggregator.builtInFallback()
            ),
            eventLimit: 10
        )
        let viewModel = EventsViewModel(eventFetcher: fetcher)

        await viewModel.refresh()

        XCTAssertNil(viewModel.error)
        XCTAssertEqual(viewModel.events.map(\.id), [
            "fixture-east-asia",
            "fixture-europe",
            "fixture-middle-east"
        ])
        XCTAssertEqual(
            Set(viewModel.regionFallbacks.map(\.region)),
            Set<Region>([.eastAsia, .europe, .middleEast])
        )
    }

    func testNewsBackedMapFetcherUsesLiveEventsWhenAvailable() async throws {
        let liveEvent = makeEvent(
            id: "live:mali",
            title: "Mali security forces report attacks",
            summary: "Russian personnel remain exposed to attacks in Mali."
        )
        let fetcher = NewsBackedEventFetcher(
            eventProvider: FallbackNewsEventProvider(
                primary: StubNewsEventProvider(events: [liveEvent]),
                fallback: NewsSourceAggregator.builtInFallback()
            ),
            eventLimit: 10
        )

        let events = try await fetcher.fetchEvents(locale: "en")

        XCTAssertEqual(events.map(\.id), ["live:mali"])
    }

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

private struct StubNewsEventProvider: NewsEventProviding {
    let events: [CrisisEvent]

    func fetchEvents(limit: Int) async throws -> [CrisisEvent] {
        Array(events.prefix(limit))
    }
}
