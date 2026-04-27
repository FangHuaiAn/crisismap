import SwiftUI

struct RelativeTimeText: View {
    let isoString: String

    var body: some View {
        Text(relativeTime(from: isoString))
            .font(.caption2)
            .foregroundStyle(Color.textSecondary)
    }
}
