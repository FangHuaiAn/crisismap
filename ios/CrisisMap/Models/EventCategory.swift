import SwiftUI

enum EventCategory: String, Codable, CaseIterable, Sendable {
    case conflict, statement, military, diplomatic
    case economic, terrorism, disaster, prediction, earthquake

    /// SF Symbol name
    var icon: String {
        switch self {
        case .conflict:   "flame.fill"
        case .statement:  "quote.bubble.fill"
        case .military:   "shield.fill"
        case .diplomatic: "flag.fill"
        case .economic:   "chart.line.uptrend.xyaxis"
        case .terrorism:  "exclamationmark.triangle.fill"
        case .disaster:   "tornado"
        case .prediction: "chart.pie.fill"
        case .earthquake: "waveform.path.ecg"
        }
    }

    var label: String {
        switch self {
        case .conflict:   String(localized: "category.conflict")
        case .statement:  String(localized: "category.statement")
        case .military:   String(localized: "category.military")
        case .diplomatic: String(localized: "category.diplomatic")
        case .economic:   String(localized: "category.economic")
        case .terrorism:  String(localized: "category.terrorism")
        case .disaster:   String(localized: "category.disaster")
        case .prediction: String(localized: "category.prediction")
        case .earthquake: String(localized: "category.earthquake")
        }
    }

    var color: Color {
        switch self {
        case .conflict:   Color.accentRed
        case .military:   Color.accentOrange
        case .terrorism:  Color.accentRed
        case .disaster:   Color.accentYellow
        case .earthquake: Color.accentYellow
        case .economic:   Color.accentBlue
        case .diplomatic: Color.accentGreen
        case .statement:  Color.textSecondary
        case .prediction: Color(hex: "#a855f7")
        }
    }
}
