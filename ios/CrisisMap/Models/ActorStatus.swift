import Foundation

struct ActorStatus: Codable, Identifiable, Sendable {
    var id: String { name }

    let name: String
    let flag: String
    let role: String
    let lastStatement: String?
    let lastStatementTime: String?
    let eventCount: Int

    var hasStatement: Bool {
        lastStatement != nil
    }
}
