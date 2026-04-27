import SwiftUI

struct EventMarkerDot: View {
    let level: ThreatLevel
    var isPrivate = false

    @State private var isPulsing = false

    var body: some View {
        ZStack(alignment: .topTrailing) {
            ZStack {
                // Pulse ring for critical
                if level == .critical {
                    Circle()
                        .fill(level.color.opacity(0.3))
                        .frame(width: level.markerSize * 2, height: level.markerSize * 2)
                        .scaleEffect(isPulsing ? 1.5 : 1.0)
                        .opacity(isPulsing ? 0 : 0.6)
                        .onAppear {
                            withAnimation(.easeOut(duration: 1.5).repeatForever(autoreverses: false)) {
                                isPulsing = true
                            }
                        }
                }

                // Glow
                Circle()
                    .fill(level.color.opacity(0.4))
                    .frame(width: level.markerSize * 1.5, height: level.markerSize * 1.5)
                    .blur(radius: 2)

                // Core dot
                Circle()
                    .fill(level.color)
                    .frame(width: level.markerSize, height: level.markerSize)
            }

            // Private badge
            if isPrivate {
                Text("🔒")
                    .font(.system(size: 6))
                    .offset(x: 4, y: -4)
            }
        }
        .frame(width: level.markerSize * 2.5, height: level.markerSize * 2.5)
    }
}

#Preview {
    HStack(spacing: 24) {
        ForEach(ThreatLevel.allCases, id: \.self) { level in
            EventMarkerDot(level: level)
        }
    }
    .padding(40)
    .background(Color.bgPrimary)
}
