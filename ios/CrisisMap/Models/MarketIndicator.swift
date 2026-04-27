import Foundation

struct MarketIndicator: Codable, Identifiable, Sendable {
    var id: String { symbol }

    let symbol: String
    let name: String
    let price: Double
    let change: Double
    let changePercent: Double
    let timestamp: String

    var isPositive: Bool { change >= 0 }

    var formattedPrice: String {
        if price >= 1000 {
            return String(format: "$%,.0f", price)
        }
        return String(format: "$%.2f", price)
    }

    var formattedChange: String {
        let sign = isPositive ? "+" : ""
        return String(format: "%@%.2f%%", sign, changePercent)
    }
}
