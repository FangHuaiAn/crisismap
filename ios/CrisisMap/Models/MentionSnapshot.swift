import Foundation

struct MentionClusterScore: Codable, Identifiable, Sendable {
    let clusterId: String
    let label: String
    let score: Double
    let sourceCount: Int
    let lastMentionAt: Date?
    let regions: [Region]
    let topics: [String]

    var id: String { clusterId }
}

struct MentionSnapshot: Codable, Sendable {
    let asOf: Date
    let halfLifeDays: Double
    let clusters: [MentionClusterScore]
}
