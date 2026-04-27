import SwiftUI

struct PolymarketContract: Codable, Identifiable, Sendable {
    let id: String
    let question: String
    let probability: Int
    let volume: Double
    let url: String?

    var probabilityColor: Color {
        if probability > 70 { return Color.accentRed }
        if probability > 40 { return Color.accentYellow }
        return Color.accentGreen
    }
}
