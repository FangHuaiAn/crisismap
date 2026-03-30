import Foundation

struct WeekEntry: Codable, Sendable {
    let week: String
    let uploaded: String
}

struct WeekIndex: Codable, Sendable {
    let weeks: [WeekEntry]
}

struct TopicsIndex: Codable, Sendable {
    let topics: [String]
}

struct ThinkTankArticle: Codable, Identifiable, Sendable {
    let id: String
    let thinkTank: String
    let title: String
    let url: String
    let date: String
    let summary: String
    let category: String
    let status: String
    let topics: [String]

    enum CodingKeys: String, CodingKey {
        case id
        case thinkTank = "think_tank"
        case title, url, date, summary, category, status, topics
    }

    init(
        id: String,
        thinkTank: String,
        title: String,
        url: String,
        date: String,
        summary: String,
        category: String,
        status: String,
        topics: [String]
    ) {
        self.id = id
        self.thinkTank = thinkTank
        self.title = title
        self.url = url
        self.date = date
        self.summary = summary
        self.category = category
        self.status = status
        self.topics = topics
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        thinkTank = try container.decode(String.self, forKey: .thinkTank)
        title = try container.decode(String.self, forKey: .title)
        url = try container.decode(String.self, forKey: .url)
        date = try container.decode(String.self, forKey: .date)
        summary = try container.decodeIfPresent(String.self, forKey: .summary) ?? ""
        category = try container.decodeIfPresent(String.self, forKey: .category) ?? "general"
        status = try container.decodeIfPresent(String.self, forKey: .status) ?? "unknown"
        topics = try container.decodeIfPresent([String].self, forKey: .topics) ?? []
    }
}

struct ThinkTankWeekly: Codable, Sendable {
    let week: String
    let startDate: String
    let endDate: String
    let generatedAt: String
    let articles: [ThinkTankArticle]

    enum CodingKeys: String, CodingKey {
        case week
        case startDate = "start_date"
        case endDate = "end_date"
        case generatedAt = "generated_at"
        case articles
    }
}
