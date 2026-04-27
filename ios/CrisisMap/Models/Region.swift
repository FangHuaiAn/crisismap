import Foundation

enum Region: String, CaseIterable, Codable, Sendable {
    case all
    case middleEast = "middle-east"
    case europe
    case eastAsia = "east-asia"
    case africa
    case americas

    var label: String {
        switch self {
        case .all:        String(localized: "region.all")
        case .middleEast: String(localized: "region.middle-east")
        case .europe:     String(localized: "region.europe")
        case .eastAsia:   String(localized: "region.east-asia")
        case .africa:     String(localized: "region.africa")
        case .americas:   String(localized: "region.americas")
        }
    }

    /// Keywords used to match events to a region (mirrors Web regions.ts)
    var keywords: [String] {
        switch self {
        case .all:
            []
        case .middleEast:
            ["iran", "iraq", "israel", "palestine", "gaza", "lebanon", "syria",
             "yemen", "saudi", "jordan", "egypt", "turkey", "qatar", "uae",
             "bahrain", "kuwait", "oman", "tehran", "baghdad", "beirut",
             "damascus", "sanaa", "riyadh", "jerusalem", "tel aviv",
             "west bank", "hezbollah", "hamas", "houthi", "irgc",
             "hormuz", "red sea", "suez", "middle east", "mideast", "mena"]
        case .europe:
            ["ukraine", "russia", "nato", "eu", "europe", "kyiv", "moscow",
             "london", "paris", "berlin", "brussels", "poland", "romania",
             "baltic", "crimea", "donbas", "belarus", "moldova"]
        case .eastAsia:
            ["china", "taiwan", "japan", "korea", "beijing", "tokyo",
             "pyongyang", "seoul", "taipei", "south china sea",
             "xi jinping", "kim jong"]
        case .africa:
            ["africa", "sudan", "sahel", "somalia", "ethiopia", "congo",
             "nigeria", "libya", "mali", "niger", "burkina", "mozambique",
             "khartoum", "mogadishu", "addis ababa"]
        case .americas:
            ["us", "united states", "america", "washington", "pentagon",
             "mexico", "venezuela", "colombia", "brazil", "canada",
             "caribbean", "cuba"]
        }
    }

    func matches(_ text: String) -> Bool {
        if self == .all { return true }
        let lower = text.lowercased()
        return keywords.contains { lower.contains($0) }
    }

    // MARK: - News Mapping

    var newsTags: [String] {
        switch self {
        case .all:
            []
        case .middleEast:
            ["middle-east", "middle_east", "mena", "mideast"]
        case .europe:
            ["europe", "eu"]
        case .eastAsia:
            ["east-asia", "east_asia", "asia", "indo-pacific", "indopacific"]
        case .africa:
            ["africa"]
        case .americas:
            ["americas", "america", "north-america", "latin-america"]
        }
    }

    static func fromNewsTag(_ tag: String) -> Region? {
        let normalized = tag
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        return Region.allCases.first { region in
            region.newsTags.contains(normalized)
        }
    }

    static func mapNewsTags(_ tags: [String]) -> [Region] {
        var result: [Region] = []

        for tag in tags {
            guard let region = fromNewsTag(tag), !result.contains(region) else { continue }
            result.append(region)
        }

        return result
    }

    // MARK: - Research Tab Mapping

    /// Categories from think tank data that map to this region
    var researchCategories: [String] {
        switch self {
        case .all:        []
        case .middleEast: ["middle_east"]
        case .europe:     ["europe"]
        case .eastAsia:   ["china_indopacific"]
        case .africa:     ["africa"]
        case .americas:   ["americas"]
        }
    }

    /// Topics from think tank data that map to this region
    var researchTopics: [String] {
        switch self {
        case .all:        []
        case .middleEast: ["Middle East"]
        case .europe:     ["Europe", "Russia", "Ukraine", "NATO"]
        case .eastAsia:   ["China", "Taiwan", "Indo-Pacific"]
        case .africa:     []
        case .americas:   ["United States"]
        }
    }

    /// Check if a think tank article belongs to this region
    func matchesArticle(_ article: ThinkTankArticle) -> Bool {
        if self == .all { return true }
        if researchCategories.contains(article.category) { return true }
        return !Set(researchTopics).intersection(article.topics).isEmpty
    }
}
