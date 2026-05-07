import Foundation

enum NewsLocalization {
    static func text(_ key: String, locale: Locale = .current) -> String {
        let normalizedCandidates = localizationCandidates(for: locale)

        for candidate in normalizedCandidates {
            if
                let path = Bundle.main.path(forResource: candidate, ofType: "lproj"),
                let bundle = Bundle(path: path)
            {
                let value = bundle.localizedString(forKey: key, value: nil, table: nil)
                if value != key {
                    return value
                }
            }
        }

        let bundleValue = Bundle.main.localizedString(forKey: key, value: nil, table: nil)
        if bundleValue != key {
            return bundleValue
        }

        return fallbackValue(for: key, locale: locale) ?? key
    }

    static func attributionBadgeText(_ attribution: NewsSourceAttribution, locale: Locale = .current) -> String {
        switch attribution {
        case .direct:
            text("news.source.attribution.direct", locale: locale)
        case .derived:
            text("news.source.attribution.derived", locale: locale)
        }
    }

    static func attributionSummaryText(_ attribution: NewsSourceAttribution, locale: Locale = .current) -> String {
        switch attribution {
        case .direct:
            text("news.source.summary.direct", locale: locale)
        case .derived:
            text("news.source.summary.derived", locale: locale)
        }
    }

    static func kindBadgeText(_ kind: NewsSourceKind, locale: Locale = .current) -> String {
        switch kind {
        case .wire:
            text("news.source.kind.wire", locale: locale)
        case .publisher:
            text("news.source.kind.publisher", locale: locale)
        case .aggregator:
            text("news.source.kind.aggregator", locale: locale)
        case .social:
            text("news.source.kind.social", locale: locale)
        }
    }

    static func kindSummaryText(_ kind: NewsSourceKind, locale: Locale = .current) -> String {
        switch kind {
        case .wire:
            text("news.source.summary.kind.wire", locale: locale)
        case .publisher:
            text("news.source.summary.kind.publisher", locale: locale)
        case .aggregator:
            text("news.source.summary.kind.aggregator", locale: locale)
        case .social:
            text("news.source.summary.kind.social", locale: locale)
        }
    }

    private static func localizationCandidates(for locale: Locale) -> [String] {
        let normalized = locale.identifier.replacingOccurrences(of: "_", with: "-")
        let parts = normalized.split(separator: "-").map(String.init)
        var candidates: [String] = [normalized]

        if parts.count >= 2 {
            candidates.append(parts.prefix(2).joined(separator: "-"))
        }

        if let language = parts.first {
            candidates.append(language)
        }

        var seen = Set<String>()
        return candidates.filter { candidate in
            !candidate.isEmpty && seen.insert(candidate).inserted
        }
    }

    private static func fallbackValue(for key: String, locale: Locale) -> String? {
        if locale.identifier.replacingOccurrences(of: "_", with: "-").hasPrefix("zh") {
            return zhHantTWFallbacks[key]
        }

        return enFallbacks[key]
    }

    private static let enFallbacks: [String: String] = [
        "news.source.attribution.direct": "Direct",
        "news.source.attribution.derived": "Derived",
        "news.source.kind.wire": "Wire",
        "news.source.kind.publisher": "Publisher",
        "news.source.kind.aggregator": "Aggregator",
        "news.source.kind.social": "Social",
        "news.source.summary.direct": "direct",
        "news.source.summary.derived": "derived",
        "news.source.summary.kind.wire": "wire",
        "news.source.summary.kind.publisher": "publisher",
        "news.source.summary.kind.aggregator": "aggregator",
        "news.source.summary.kind.social": "social",
        "news.sources.count": "%lld sources",
        "news.topic.all": "All Topics"
    ]

    private static let zhHantTWFallbacks: [String: String] = [
        "news.source.attribution.direct": "直接來源",
        "news.source.attribution.derived": "轉載彙整",
        "news.source.kind.wire": "通訊社",
        "news.source.kind.publisher": "發行媒體",
        "news.source.kind.aggregator": "聚合器",
        "news.source.kind.social": "社群",
        "news.source.summary.direct": "直接來源",
        "news.source.summary.derived": "轉載彙整",
        "news.source.summary.kind.wire": "通訊社",
        "news.source.summary.kind.publisher": "發行媒體",
        "news.source.summary.kind.aggregator": "聚合器",
        "news.source.summary.kind.social": "社群",
        "news.sources.count": "%lld 個來源",
        "news.topic.all": "所有主題"
    ]
}
