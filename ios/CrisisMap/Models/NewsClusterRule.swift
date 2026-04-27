import Foundation

struct NewsClusterRuleSet: Codable, Sendable {
    let version: String
    let rules: [NewsClusterRule]
}

struct NewsClusterRule: Codable, Identifiable, Sendable {
    let clusterId: String
    let label: String
    let priority: Int
    let keywordsAny: [String]
    let keywordsAll: [String]
    let regions: [Region]
    let topics: [String]

    var id: String { clusterId }

    init(
        clusterId: String,
        label: String,
        priority: Int,
        keywordsAny: [String],
        keywordsAll: [String] = [],
        regions: [Region] = [],
        topics: [String] = []
    ) {
        self.clusterId = clusterId
        self.label = label
        self.priority = priority
        self.keywordsAny = keywordsAny
        self.keywordsAll = keywordsAll
        self.regions = regions
        self.topics = topics
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        clusterId = try container.decode(String.self, forKey: .clusterId)
        label = try container.decode(String.self, forKey: .label)
        priority = try container.decode(Int.self, forKey: .priority)
        keywordsAny = try container.decodeIfPresent([String].self, forKey: .keywordsAny) ?? []
        keywordsAll = try container.decodeIfPresent([String].self, forKey: .keywordsAll) ?? []
        regions = try container.decodeIfPresent([Region].self, forKey: .regions) ?? []
        topics = try container.decodeIfPresent([String].self, forKey: .topics) ?? []
    }

    var normalizedKeywordsAny: [String] {
        keywordsAny.map(Self.normalize)
    }

    var normalizedKeywordsAll: [String] {
        keywordsAll.map(Self.normalize)
    }

    static func prioritized(_ rules: [NewsClusterRule]) -> [NewsClusterRule] {
        rules.sorted {
            if $0.priority == $1.priority {
                return $0.clusterId < $1.clusterId
            }
            return $0.priority < $1.priority
        }
    }

    private static func normalize(_ keyword: String) -> String {
        keyword
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
    }
}
