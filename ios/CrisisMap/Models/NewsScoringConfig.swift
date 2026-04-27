import Foundation

struct NewsScoringConfig: Codable, Sendable {
    var halfLifeDays: Double
    var precomputeHour: Int
    var precomputeMinute: Int

    init(halfLifeDays: Double, precomputeHour: Int = 0, precomputeMinute: Int = 0) {
        self.halfLifeDays = halfLifeDays
        self.precomputeHour = precomputeHour
        self.precomputeMinute = precomputeMinute
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        halfLifeDays = try container.decode(Double.self, forKey: .halfLifeDays)
        precomputeHour = try container.decodeIfPresent(Int.self, forKey: .precomputeHour) ?? 0
        precomputeMinute = try container.decodeIfPresent(Int.self, forKey: .precomputeMinute) ?? 0
    }

    static let `default` = NewsScoringConfig(
        halfLifeDays: 180,
        precomputeHour: 0,
        precomputeMinute: 0
    )

    var safeHalfLifeDays: Double {
        max(halfLifeDays, 0.0001)
    }
}
