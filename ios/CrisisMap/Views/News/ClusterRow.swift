import SwiftUI

struct ClusterRow: View {
    @Environment(\.locale) private var locale

    let cluster: NewsClusterSummary

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                Text(cluster.label)
                    .font(.headline)
                    .foregroundStyle(Color.textPrimary)

                Spacer()

                Text(cluster.score, format: .number.precision(.fractionLength(2)))
                    .font(.system(.subheadline, design: .monospaced).bold())
                    .foregroundStyle(Color.accentBlue)
            }

            HStack(spacing: 10) {
                Label(sourceCountText, systemImage: "dot.radiowaves.left.and.right")
                    .font(.caption)
                    .foregroundStyle(Color.textSecondary)

                if let lastMentionAt = cluster.lastMentionAt {
                    Text(lastMentionAt, style: .relative)
                        .font(.caption)
                        .foregroundStyle(Color.textSecondary)
                }
            }

            if !cluster.topics.isEmpty {
                Text(cluster.topics.joined(separator: "  ·  "))
                    .font(.caption2)
                    .foregroundStyle(Color.textSecondary)
                    .lineLimit(1)
            }

            if let rowSourceSummary = cluster.rowSourceSummary(locale: locale) {
                Text(rowSourceSummary)
                    .font(.caption2)
                    .foregroundStyle(Color.textSecondary)
                    .lineLimit(1)
            }
        }
        .padding(12)
        .background(Color.bgSecondary)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    private var sourceCountText: String {
        let format = NewsLocalization.text("news.sources.count", locale: locale)
        return String.localizedStringWithFormat(format, cluster.sourceCount)
    }
}
