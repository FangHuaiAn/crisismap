import SwiftUI

struct ClusterDetailView: View {
    @Environment(\.locale) private var locale

    let cluster: NewsClusterSummary

    var body: some View {
        List {
            Section("news.signal.section") {
                HStack {
                    Text("news.signal.mentionIndex")
                    Spacer()
                    Text(cluster.score, format: .number.precision(.fractionLength(2)))
                        .font(.system(.body, design: .monospaced).bold())
                }

                HStack {
                    Text("news.signal.distinctSources")
                    Spacer()
                    Text("\(cluster.sourceCount)")
                }

                if !cluster.sources.isEmpty {
                    Text(cluster.sources.joined(separator: ", "))
                        .font(.caption)
                        .foregroundStyle(Color.textSecondary)
                }

                if let attributionSummary = cluster.detailAttributionSummary(locale: locale) {
                    HStack {
                        Text("news.signal.attributionMix")
                        Spacer()
                        Text(attributionSummary)
                            .font(.caption)
                            .foregroundStyle(Color.textSecondary)
                    }
                }

                if let sourceKindSummary = cluster.sourceKindSummary(locale: locale) {
                    HStack {
                        Text("news.signal.sourceTypes")
                        Spacer()
                        Text(sourceKindSummary)
                            .font(.caption)
                            .foregroundStyle(Color.textSecondary)
                    }
                }
            }

            Section("news.events.recent") {
                ForEach(cluster.events) { event in
                    eventRow(for: event)
                }
            }
        }
        .navigationTitle(cluster.label)
        .navigationBarTitleDisplayMode(.inline)
        .scrollContentBackground(.hidden)
        .background(Color.bgPrimary)
    }

    @ViewBuilder
    private func eventRow(for event: CrisisEvent) -> some View {
        let display = NewsLocalizedEventDisplay(event: event, localizedContent: nil)

        VStack(alignment: .leading, spacing: 6) {
            Text(display.displayTitle)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color.textPrimary)

            Text(display.displaySummary)
                .font(.caption)
                .foregroundStyle(Color.textSecondary)
                .lineLimit(3)

            HStack {
                SourceBadge(source: event.source, tier: event.sourceTier)

                if let attributionText = NewsSourcePresentation.attributionText(for: event, locale: locale) {
                    metadataChip(attributionText)
                }

                if let kindText = NewsSourcePresentation.kindText(for: event, locale: locale) {
                    metadataChip(kindText)
                }

                Spacer()
                Text(event.date, style: .relative)
                    .font(.caption2)
                    .foregroundStyle(Color.textSecondary)
            }

            if let outletSubtitle = NewsSourcePresentation.outletSubtitle(for: event) {
                Text(outletSubtitle)
                    .font(.caption2)
                    .foregroundStyle(Color.textSecondary)
            }
        }
        .padding(.vertical, 4)
    }

    @ViewBuilder
    private func metadataChip(_ text: String) -> some View {
        Text(text)
            .font(.caption2)
            .foregroundStyle(Color.textSecondary)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Color.bgSecondary)
            .clipShape(Capsule())
    }
}
