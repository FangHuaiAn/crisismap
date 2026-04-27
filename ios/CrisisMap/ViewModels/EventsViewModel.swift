import Foundation

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
            let fetched = try await APIClient.shared.fetchEvents(locale: apiLocale)
            events = fetched
            error = nil
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }
}
