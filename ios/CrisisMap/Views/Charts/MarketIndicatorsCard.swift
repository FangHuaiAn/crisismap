import SwiftUI

struct MarketIndicatorsCard: View {
    let indicators: [MarketIndicator]

    var body: some View {
        DashboardCard(title: String(localized: "chart.marketIndicators"), icon: "chart.line.uptrend.xyaxis") {
            if indicators.isEmpty {
                Text("Loading...")
                    .font(.caption)
                    .foregroundStyle(Color.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(indicators) { indicator in
                            indicatorCard(indicator)
                        }
                    }
                }
            }
        }
    }

    private func indicatorCard(_ ind: MarketIndicator) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(ind.name)
                .font(.caption2)
                .foregroundStyle(Color.textSecondary)

            Text(ind.formattedPrice)
                .font(.subheadline.bold().monospacedDigit())
                .foregroundStyle(Color.textPrimary)

            HStack(spacing: 2) {
                Image(systemName: ind.isPositive ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                    .font(.system(size: 8))
                Text(ind.formattedChange)
                    .font(.caption2.bold().monospacedDigit())
            }
            .foregroundStyle(ind.isPositive ? Color.accentGreen : Color.accentRed)
        }
        .padding(10)
        .frame(width: 110)
        .background(Color.bgTertiary)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
