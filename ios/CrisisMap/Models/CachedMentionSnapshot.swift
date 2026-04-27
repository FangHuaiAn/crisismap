import Foundation
import SwiftData

@Model
final class CachedMentionSnapshot {
    @Attribute(.unique) var key: String
    var asOf: Date
    var halfLifeDays: Double
    var payload: Data
    var generatedAt: Date

    init(asOf: Date, halfLifeDays: Double, payload: Data, generatedAt: Date = .now) {
        self.key = Self.makeKey(asOf: asOf)
        self.asOf = asOf
        self.halfLifeDays = halfLifeDays
        self.payload = payload
        self.generatedAt = generatedAt
    }

    nonisolated static func makeKey(asOf: Date) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.string(from: asOf)
    }
}
