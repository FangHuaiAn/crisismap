import Foundation

enum NewsSourceHeuristics {
    private static let geoKeywords = [
        "crisis", "conflict", "military", "attack", "strike",
        "war", "nuclear", "sanction", "sanctions", "missile", "troops",
        "bombing", "invasion", "casualties", "killed", "weapon",
        "airstrike", "explosion", "terror", "hostage", "coup",
        "blockade", "escalation", "martial"
    ]

    private static let criticalKeywords = [
        "nuclear", "airstrike", "invasion", "war declared", "missile launch",
        "chemical weapon", "biological weapon", "nuke", "wmd"
    ]

    private static let highKeywords = [
        "strike", "attack", "casualties", "killed", "bombing", "explosion",
        "military operation", "retaliation", "troops deployed", "sanctions",
        "blockade", "no-fly zone", "martial law"
    ]

    private static let mediumKeywords = [
        "tensions", "escalation", "threat", "warning", "mobilization",
        "protest", "embargo", "diplomatic crisis", "cyber attack",
        "oil price", "market crash"
    ]

    private static let criticalActors = [
        "Biden", "Trump", "Netanyahu", "Khamenei", "IRGC", "IDF",
        "Pentagon", "NATO", "Hezbollah", "Hamas", "Russia", "Ukraine",
        "China", "Taiwan", "Israel", "Iran"
    ]

    private static let fallbackTimestamp = ISO8601DateFormatter().string(from: Date(timeIntervalSince1970: 0))

    static func hashString(_ value: String) -> String {
        var hash: UInt64 = 1469598103934665603
        for byte in value.utf8 {
            hash ^= UInt64(byte)
            hash = hash &* 1099511628211
        }
        return String(hash, radix: 36)
    }

    static func stripHTML(_ html: String) -> String {
        html
            .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
            .replacingOccurrences(of: "&nbsp;", with: " ")
            .replacingOccurrences(of: "&amp;", with: "&")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    static func detectCategory(title: String, description: String) -> EventCategory {
        let text = "\(title) \(description)".lowercased()
        let patterns: [(regex: String, category: EventCategory)] = [
            (#"\b(?:nuclear|missile(?:s)?|troops?|military|army|navy|pentagon|defense)\b"#, .military),
            (#"\b(?:attack(?:s)?|war|combat|battle|fighting|clash(?:es)?|killed|casualties)\b"#, .conflict),
            (#"\b(?:terror|isis|al.?qaeda|bomb(?:s)?|explosion(?:s)?|hostage(?:s)?)\b"#, .terrorism),
            (#"\b(?:earthquake(?:s)?|tsunami|hurricane|flood(?:s)?|volcano(?:es)?|wildfire(?:s)?)\b"#, .disaster),
            (#"(?:\b(?:diplomat(?:s)?|embassy|treaty|summit|negotiate(?:s|d|ing)?|united nations)\b|u\.n\.)"#, .diplomatic),
            (#"\b(?:sanction(?:s)?|tariff(?:s)?|trade war|market|econom(?:y|ic)|inflation)\b"#, .economic),
            (#"\b(?:statement|says|warns|announces|declares|condemns|urges)\b"#, .statement)
        ]

        for pattern in patterns where text.range(of: pattern.regex, options: .regularExpression) != nil {
            return pattern.category
        }

        return .statement
    }

    static func scoreThreatLevel(title: String, description: String, category: EventCategory) -> ThreatLevel {
        let text = "\(title) \(description)".lowercased()
        var score = categoryBoost[category] ?? 0

        if containsAnyToken(in: text, keywords: criticalKeywords) {
            return .critical
        }

        for keyword in highKeywords where matchesToken(in: text, keyword: keyword) {
            score += 2
        }

        for keyword in mediumKeywords where matchesToken(in: text, keyword: keyword) {
            score += 1
        }

        if score >= 4 { return .high }
        if score >= 2 { return .medium }
        if score >= 1 { return .low }
        return .info
    }

    static func extractActor(from text: String) -> String? {
        criticalActors.first { matchesToken(in: text, keyword: $0) }
    }

    static func looksGeopolitical(_ text: String) -> Bool {
        containsAnyToken(in: text.lowercased(), keywords: geoKeywords)
    }

    static var oldTimestampFallback: String {
        fallbackTimestamp
    }

    private static func containsAnyToken(in text: String, keywords: [String]) -> Bool {
        keywords.contains { matchesToken(in: text, keyword: $0) }
    }

    private static func matchesToken(in text: String, keyword: String) -> Bool {
        let pattern = #"\b"# + NSRegularExpression.escapedPattern(for: keyword) + #"\b"#
        return text.range(of: pattern, options: [.regularExpression, .caseInsensitive]) != nil
    }

    private static let categoryBoost: [EventCategory: Int] = [
        .conflict: 2,
        .military: 2,
        .terrorism: 2,
        .disaster: 1,
        .statement: 0,
        .diplomatic: 0,
        .economic: 0,
        .prediction: -1,
        .earthquake: 1
    ]
}
