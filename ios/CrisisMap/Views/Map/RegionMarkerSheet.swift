import SwiftUI

struct RegionMarkerSheet: View {
    let fallback: RegionFallback

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(fallback.region.label)
                                .font(.title3.bold())
                                .foregroundStyle(Color.textPrimary)
                            Text("\(fallback.events.count) unplaced events")
                                .font(.caption)
                                .foregroundStyle(Color.textSecondary)
                        }
                        Spacer()
                    }
                    .listRowBackground(Color.bgSecondary)
                }

                Section("News") {
                    ForEach(fallback.events) { event in
                        eventRow(event)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.bgPrimary)
            .navigationTitle("Region Context")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func eventRow(_ event: CrisisEvent) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(event.title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color.textPrimary)
            Text(event.summary)
                .font(.caption)
                .foregroundStyle(Color.textSecondary)
                .lineLimit(3)
            HStack(spacing: 8) {
                ThreatBadge(level: event.level)
                SourceBadge(source: event.source, tier: event.sourceTier)
            }
        }
        .padding(.vertical, 4)
        .listRowBackground(Color.bgSecondary)
    }
}
