import SwiftUI

struct EventRow: View {
    let event: CrisisEvent

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Top row: level + category + time
            HStack(spacing: 6) {
                ThreatBadge(level: event.level)
                CategoryIcon(category: event.category, size: 11)
                Text(event.category.label)
                    .font(.caption2)
                    .foregroundStyle(event.category.color)
                Spacer()
                RelativeTimeText(isoString: event.timestamp)
            }

            // Title
            Text(event.title)
                .font(.subheadline.bold())
                .foregroundStyle(Color.textPrimary)
                .lineLimit(2)

            // Summary
            Text(event.summary)
                .font(.caption)
                .foregroundStyle(Color.textSecondary)
                .lineLimit(2)

            // Footer: location + source
            HStack(spacing: 10) {
                if let location = event.location {
                    HStack(spacing: 3) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 10))
                            .foregroundStyle(Color.accentBlue)
                        Text(location.name)
                            .font(.caption2)
                            .foregroundStyle(Color.textSecondary)
                    }
                }
                Spacer()
                SourceBadge(source: event.source, tier: event.sourceTier)
            }
        }
        .padding(12)
        .background(Color.bgSecondary)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.border, lineWidth: 1)
        )
    }
}
