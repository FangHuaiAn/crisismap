import Charts
import SwiftUI

struct CategoryBreakdownCard: View {
    let events: [CrisisEvent]

    private var counts: [(category: EventCategory, count: Int)] {
        EventCategory.allCases
            .map { cat in (cat, events.filter { $0.category == cat }.count) }
            .filter { $0.count > 0 }
            .sorted { $0.count > $1.count }
    }

    var body: some View {
        DashboardCard(title: String(localized: "chart.categories"), icon: "tag.fill") {
            HStack(spacing: 16) {
                // Pie chart
                Chart(counts, id: \.category) { item in
                    SectorMark(
                        angle: .value("Count", item.count),
                        innerRadius: .ratio(0.5),
                        angularInset: 1
                    )
                    .foregroundStyle(item.category.color)
                }
                .frame(width: 100, height: 100)

                // Legend
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(counts.prefix(6), id: \.category) { item in
                        HStack(spacing: 6) {
                            Circle()
                                .fill(item.category.color)
                                .frame(width: 6, height: 6)
                            Text(item.category.label)
                                .font(.caption2)
                                .foregroundStyle(Color.textSecondary)
                            Spacer()
                            Text("\(item.count)")
                                .font(.caption2.bold())
                                .foregroundStyle(Color.textPrimary)
                        }
                    }
                }
            }
        }
    }
}
