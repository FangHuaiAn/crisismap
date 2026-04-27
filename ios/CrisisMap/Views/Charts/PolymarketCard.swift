import Charts
import SwiftUI

struct PolymarketCard: View {
    let contracts: [PolymarketContract]

    var body: some View {
        DashboardCard(title: String(localized: "chart.predictionMarkets"), icon: "chart.pie.fill") {
            if contracts.isEmpty {
                Text("markets.noActive")
                    .font(.caption)
                    .foregroundStyle(Color.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
            } else {
                VStack(spacing: 8) {
                    ForEach(contracts.prefix(8)) { contract in
                        contractRow(contract)
                    }
                }
            }
        }
    }

    private func contractRow(_ contract: PolymarketContract) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(contract.question)
                .font(.caption)
                .foregroundStyle(Color.textPrimary)
                .lineLimit(2)

            HStack(spacing: 8) {
                // Probability bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.bgTertiary)

                        RoundedRectangle(cornerRadius: 3)
                            .fill(contract.probabilityColor)
                            .frame(width: geo.size.width * CGFloat(contract.probability) / 100)
                    }
                }
                .frame(height: 6)

                Text("\(contract.probability)%")
                    .font(.caption2.bold().monospacedDigit())
                    .foregroundStyle(contract.probabilityColor)
                    .frame(width: 36, alignment: .trailing)
            }
        }
        .padding(8)
        .background(Color.bgTertiary.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .onTapGesture {
            if let urlStr = contract.url, let url = URL(string: urlStr) {
                UIApplication.shared.open(url)
            }
        }
    }
}
