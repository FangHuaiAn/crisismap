import Foundation

/// News sources return normalized `CrisisEvent` values and should honor the requested limit.
protocol NewsDataSource: Sendable {
    var id: String { get }
    var name: String { get }
    var isEnabled: Bool { get }
    func fetch(limit: Int) async throws -> [CrisisEvent]
}
