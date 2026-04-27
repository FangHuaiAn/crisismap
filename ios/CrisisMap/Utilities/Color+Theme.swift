import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double((rgbValue & 0x0000FF)) / 255.0

        self.init(red: r, green: g, blue: b)
    }

    // Backgrounds — match Web CSS custom properties exactly
    static let bgPrimary   = Color(hex: "#0a0a0f")
    static let bgSecondary = Color(hex: "#12121a")
    static let bgTertiary  = Color(hex: "#1a1a2e")
    static let border      = Color(hex: "#2a2a3e")

    // Text
    static let textPrimary   = Color(hex: "#e8e8f0")
    static let textSecondary = Color(hex: "#9898b0")

    // Accents
    static let accentRed    = Color(hex: "#ef4444")
    static let accentOrange = Color(hex: "#f97316")
    static let accentYellow = Color(hex: "#eab308")
    static let accentBlue   = Color(hex: "#3b82f6")
    static let accentGreen  = Color(hex: "#22c55e")
}
