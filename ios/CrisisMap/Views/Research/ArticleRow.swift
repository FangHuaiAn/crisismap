import SwiftUI

struct ArticleRow: View {
    let article: ThinkTankArticle

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Header: think tank + category + date
            HStack {
                Label(article.thinkTank, systemImage: "building.columns.fill")
                    .font(.caption)
                    .foregroundStyle(Color.textSecondary)

                Text("\u{00B7}")
                    .foregroundStyle(Color.textSecondary)

                Text(article.category)
                    .font(.caption)
                    .foregroundStyle(Color.textSecondary)

                Spacer()

                Text(article.date)
                    .font(.caption2)
                    .foregroundStyle(Color.textSecondary)
            }

            // Title
            Text(article.title)
                .font(.subheadline.bold())
                .foregroundStyle(Color.textPrimary)
                .lineLimit(2)

            // Summary
            if !article.summary.isEmpty {
                Text(article.summary)
                    .font(.caption)
                    .foregroundStyle(Color.textSecondary)
                    .lineLimit(2)
            }

            // Topics
            if !article.topics.isEmpty {
                HStack(spacing: 4) {
                    Image(systemName: "tag.fill")
                        .font(.caption2)
                        .foregroundStyle(Color.accentBlue)
                    Text(article.topics.joined(separator: " \u{00B7} "))
                        .font(.caption2)
                        .foregroundStyle(Color.accentBlue)
                        .lineLimit(1)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
