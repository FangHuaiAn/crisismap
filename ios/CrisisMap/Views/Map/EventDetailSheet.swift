import SwiftUI

struct EventDetailSheet: View {
    let event: CrisisEvent

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header row
            HStack {
                ThreatBadge(level: event.level, showLabel: true)
                CategoryIcon(category: event.category)
                Text(event.category.label)
                    .font(.caption)
                    .foregroundStyle(Color.textSecondary)
                Spacer()
                RelativeTimeText(isoString: event.timestamp)
            }

            // Title
            Text(event.title)
                .font(.headline)
                .foregroundStyle(Color.textPrimary)
                .fixedSize(horizontal: false, vertical: true)

            // Summary
            Text(event.summary)
                .font(.subheadline)
                .foregroundStyle(Color.textSecondary)
                .fixedSize(horizontal: false, vertical: true)

            Divider()
                .background(Color.border)

            // Footer
            HStack(spacing: 12) {
                // Location
                if let location = event.location {
                    HStack(spacing: 4) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.caption)
                            .foregroundStyle(Color.accentBlue)
                        Text(location.name)
                            .font(.caption)
                            .foregroundStyle(Color.textSecondary)
                    }
                }

                Spacer()

                SourceBadge(source: event.source, tier: event.sourceTier)
            }

            // Read article link
            if let urlString = event.url, let url = URL(string: urlString) {
                Link(destination: url) {
                    HStack(spacing: 4) {
                        Text("map.readArticle")
                        Image(systemName: "arrow.up.right.square")
                    }
                    .font(.caption.bold())
                    .foregroundStyle(Color.accentBlue)
                }
                .padding(.top, 4)
            }
        }
        .padding(20)
        .background(Color.bgSecondary)
    }
}
