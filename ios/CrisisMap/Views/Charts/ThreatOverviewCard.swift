import Charts
import SwiftUI

struct ThreatOverviewCard: View {
    let events: [CrisisEvent]

    private var counts: [(level: ThreatLevel, count: Int)] {
        ThreatLevel.allCases.map { level in
            (level, events.filter { $0.level == level }.count)
        }
    }

    var body: some View {
        DashboardCard(title: String(localized: "chart.threatOverview"), icon: "shield.fill") {
            VStack(spacing: 12) {
                // Big number
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("\(events.count)")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.textPrimary)
                    Text("chart.events")
                        .font(.caption)
                        .foregroundStyle(Color.textSecondary)
                }

                // Bar chart
                Chart(counts, id: \.level) { item in
                    BarMark(
                        x: .value("Level", item.level.label),
                        y: .value("Count", item.count)
                    )
                    .foregroundStyle(item.level.color)
                    .cornerRadius(4)
                }
                .chartXAxis {
                    AxisMarks { value in
                        AxisValueLabel()
                            .font(.system(size: 9))
                            .foregroundStyle(Color.textSecondary)
                    }
                }
                .chartYAxis {
                    AxisMarks { value in
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                            .foregroundStyle(Color.border)
                        AxisValueLabel()
                            .font(.system(size: 9))
                            .foregroundStyle(Color.textSecondary)
                    }
                }
                .frame(height: 140)
            }
        }
    }
}
