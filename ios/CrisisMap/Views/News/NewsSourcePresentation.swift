import Foundation

enum NewsSourcePresentation {
    static func attributionText(for event: CrisisEvent) -> String? {
        switch event.newsSource?.attribution {
        case .direct:
            "Direct"
        case .derived:
            "Derived"
        case nil:
            nil
        }
    }

    static func kindText(for event: CrisisEvent) -> String? {
        switch event.newsSource?.kind {
        case .wire:
            "Wire"
        case .publisher:
            "Publisher"
        case .aggregator:
            "Aggregator"
        case .social:
            "Social"
        case nil:
            nil
        }
    }

    static func outletSubtitle(for event: CrisisEvent) -> String? {
        if let outlet = normalized(event.newsSource?.originalOutlet), !outlet.isEmpty {
            if matchesDisplaySource(outlet, event: event) {
                return nil
            }
            return outlet
        }

        if let domain = normalized(event.newsSource?.domain), !domain.isEmpty {
            if matchesDisplaySource(domain, event: event) {
                return nil
            }
            return domain
        }

        return nil
    }

    private static func normalized(_ value: String?) -> String? {
        value?.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private static func matchesDisplaySource(_ value: String, event: CrisisEvent) -> Bool {
        let displaySource = normalized(event.newsSource?.displayName ?? event.source) ?? event.source
        return value.caseInsensitiveCompare(displaySource) == .orderedSame
    }
}
