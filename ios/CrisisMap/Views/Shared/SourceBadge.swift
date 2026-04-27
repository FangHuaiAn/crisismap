import SwiftUI

struct SourceBadge: View {
    let source: String
    let tier: SourceTier

    var body: some View {
        HStack(spacing: 3) {
            if tier == .private {
                Image(systemName: "lock.fill")
                    .font(.system(size: 8))
            }
            Text(source)
        }
        .font(.caption2)
        .foregroundStyle(Color.textSecondary)
    }
}
