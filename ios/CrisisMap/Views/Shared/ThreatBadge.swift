import SwiftUI

struct ThreatBadge: View {
    let level: ThreatLevel
    var showLabel = false

    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(level.color)
                .frame(width: 8, height: 8)

            if showLabel {
                Text(level.label)
                    .font(.caption2.bold())
                    .foregroundStyle(level.color)
            }
        }
    }
}

#Preview {
    VStack(spacing: 8) {
        ForEach(ThreatLevel.allCases, id: \.self) { level in
            ThreatBadge(level: level, showLabel: true)
        }
    }
    .padding()
    .background(Color.bgPrimary)
}
