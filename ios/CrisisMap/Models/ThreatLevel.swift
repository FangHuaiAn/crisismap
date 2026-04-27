import SwiftUI

enum ThreatLevel: String, Codable, CaseIterable, Sendable {
    case critical, high, medium, low, info

    var color: Color {
        switch self {
        case .critical: Color.accentRed
        case .high:     Color.accentOrange
        case .medium:   Color.accentYellow
        case .low:      Color.accentBlue
        case .info:     Color.textSecondary
        }
    }

    var markerSize: CGFloat {
        switch self {
        case .critical: 16
        case .high:     12
        case .medium:   10
        case .low:      8
        case .info:     6
        }
    }

    var label: String {
        switch self {
        case .critical: String(localized: "level.critical")
        case .high:     String(localized: "level.high")
        case .medium:   String(localized: "level.medium")
        case .low:      String(localized: "level.low")
        case .info:     String(localized: "level.info")
        }
    }

    var sortOrder: Int {
        switch self {
        case .critical: 0
        case .high:     1
        case .medium:   2
        case .low:      3
        case .info:     4
        }
    }
}
