import CoreLocation
import Foundation

protocol EventFetching: Sendable {
    func fetchEvents(locale: String) async throws -> [CrisisEvent]
}

extension APIClient: EventFetching {}

struct RegionFallback: Identifiable, Sendable {
    let region: Region
    let lat: Double
    let lng: Double
    let events: [CrisisEvent]

    var id: String { "region:\(region.rawValue)" }

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
}

@MainActor
@Observable
final class EventsViewModel {
    var events: [CrisisEvent] = []
    var isLoading = false
    var error: String?

    // Filters
    var selectedRegion: Region = .all
    var selectedCategories: Set<EventCategory> = []
    var selectedLevels: Set<ThreatLevel> = []
    var searchText: String = ""

    // Selection
    var selectedEventId: String?

    private var pollingTask: Task<Void, Never>?
    private let eventFetcher: any EventFetching

    init(eventFetcher: any EventFetching = APIClient.shared) {
        self.eventFetcher = eventFetcher
    }

    /// Detect device locale for API translation
    var apiLocale: String {
        let lang = Locale.current.language.languageCode?.identifier ?? "en"
        return lang == "zh" ? "zh-TW" : "en"
    }

    var filteredEvents: [CrisisEvent] {
        events.filter { event in
            // Region
            if selectedRegion != .all {
                let text = "\(event.title) \(event.summary) \(event.location?.name ?? "") \(event.location?.country ?? "")"
                if !selectedRegion.matches(text) { return false }
            }

            // Categories
            if !selectedCategories.isEmpty && !selectedCategories.contains(event.category) {
                return false
            }

            // Levels
            if !selectedLevels.isEmpty && !selectedLevels.contains(event.level) {
                return false
            }

            // Search
            if !searchText.isEmpty {
                let q = searchText.lowercased()
                let haystack = "\(event.title) \(event.summary) \(event.source)".lowercased()
                if !haystack.contains(q) { return false }
            }

            return true
        }
    }

    var eventsWithLocation: [CrisisEvent] {
        filteredEvents.filter { $0.location != nil }
    }

    var regionFallbacks: [RegionFallback] {
        let unlocatedByRegion = Dictionary(grouping: filteredEvents.filter { $0.location == nil }) { event in
            inferFallbackRegion(for: event)
        }

        return Region.allCases.compactMap { region in
            guard region != .all,
                  let events = unlocatedByRegion[region],
                  !events.isEmpty,
                  let anchor = region.fallbackAnchor else {
                return nil
            }

            return RegionFallback(
                region: region,
                lat: anchor.lat,
                lng: anchor.lng,
                events: events.sorted { $0.date > $1.date }
            )
        }
    }

    var selectedEvent: CrisisEvent? {
        guard let id = selectedEventId else { return nil }
        return events.first { $0.id == id }
    }

    var activeFilterCount: Int {
        var count = 0
        if selectedRegion != .all { count += 1 }
        if !selectedCategories.isEmpty { count += selectedCategories.count }
        if !selectedLevels.isEmpty { count += selectedLevels.count }
        if !searchText.isEmpty { count += 1 }
        return count
    }

    // MARK: - Polling

    func startPolling() {
        guard pollingTask == nil else { return }
        pollingTask = Task {
            while !Task.isCancelled {
                await refresh()
                try? await Task.sleep(for: .seconds(30))
            }
        }
    }

    func stopPolling() {
        pollingTask?.cancel()
        pollingTask = nil
    }

    func refresh() async {
        if events.isEmpty { isLoading = true }
        do {
            let fetched = try await eventFetcher.fetchEvents(locale: apiLocale)
            events = fetched
            error = nil
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }

    private func inferFallbackRegion(for event: CrisisEvent) -> Region {
        let text = [
            event.title,
            event.summary,
            event.source,
            event.actor ?? "",
            event.location?.name ?? "",
            event.location?.country ?? "",
            (event.entities ?? []).joined(separator: " ")
        ]
        .joined(separator: " ")

        return Region.allCases.first { region in
            region != .all && region.matches(text)
        } ?? .all
    }
}

private extension Region {
    var fallbackAnchor: (lat: Double, lng: Double)? {
        switch self {
        case .all:
            nil
        case .middleEast:
            (31.7683, 35.2137)
        case .europe:
            (50.1109, 8.6821)
        case .eastAsia:
            (23.6978, 120.9605)
        case .africa:
            (9.0820, 8.6753)
        case .americas:
            (19.4326, -99.1332)
        }
    }
}
