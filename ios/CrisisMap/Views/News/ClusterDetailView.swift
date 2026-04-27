import SwiftUI

struct ClusterDetailView: View {
    let cluster: NewsClusterSummary

    var body: some View {
        List {
            Section("Signal") {
                HStack {
                    Text("Mention Index")
                    Spacer()
                    Text(cluster.score, format: .number.precision(.fractionLength(2)))
                        .font(.system(.body, design: .monospaced).bold())
                }

                HStack {
                    Text("Distinct Sources")
                    Spacer()
                    Text("\(cluster.sourceCount)")
                }

                if !cluster.sources.isEmpty {
                    Text(cluster.sources.joined(separator: ", "))
                        .font(.caption)
                        .foregroundStyle(Color.textSecondary)
                }

                if let attributionSummary = cluster.detailAttributionSummary {
                    HStack {
                        Text("Attribution Mix")
                        Spacer()
                        Text(attributionSummary)
                            .font(.caption)
                            .foregroundStyle(Color.textSecondary)
                    }
                }

                if let sourceKindSummary = cluster.sourceKindSummary {
                    HStack {
                        Text("Source Types")
                        Spacer()
                        Text(sourceKindSummary)
                            .font(.caption)
                            .foregroundStyle(Color.textSecondary)
                    }
                }
            }

            Section("Recent Events") {
                ForEach(cluster.events) { event in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(event.title)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Color.textPrimary)

                        Text(event.summary)
                            .font(.caption)
                            .foregroundStyle(Color.textSecondary)
                            .lineLimit(3)

                        HStack {
                            SourceBadge(source: event.source, tier: event.sourceTier)

                            if let attributionText = NewsSourcePresentation.attributionText(for: event) {
                                metadataChip(attributionText)
                            }

                            if let kindText = NewsSourcePresentation.kindText(for: event) {
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
            }
        }
        .navigationTitle(cluster.label)
        .navigationBarTitleDisplayMode(.inline)
        .scrollContentBackground(.hidden)
        .background(Color.bgPrimary)
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
