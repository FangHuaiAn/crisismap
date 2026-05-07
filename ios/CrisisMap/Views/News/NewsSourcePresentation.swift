import Foundation

enum NewsSourcePresentation {
    static func attributionText(for event: CrisisEvent) -> String? {
        attributionText(for: event, locale: Locale(identifier: "en"))
    }

    static func attributionText(for event: CrisisEvent, locale: Locale) -> String? {
        guard let attribution = event.newsSource?.attribution else {
            return nil
        }

        return NewsLocalization.attributionBadgeText(attribution, locale: locale)
    }

    static func kindText(for event: CrisisEvent) -> String? {
        kindText(for: event, locale: Locale(identifier: "en"))
    }

    static func kindText(for event: CrisisEvent, locale: Locale) -> String? {
        guard let kind = event.newsSource?.kind else {
            return nil
        }

        return NewsLocalization.kindBadgeText(kind, locale: locale)
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
