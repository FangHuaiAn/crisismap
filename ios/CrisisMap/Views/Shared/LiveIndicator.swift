import SwiftUI

struct LiveIndicator: View {
    @State private var isPulsing = false

    var body: some View {
        HStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(Color.accentGreen.opacity(0.4))
                    .frame(width: 10, height: 10)
                    .scaleEffect(isPulsing ? 1.8 : 1.0)
                    .opacity(isPulsing ? 0 : 0.6)

                Circle()
                    .fill(Color.accentGreen)
                    .frame(width: 6, height: 6)
            }

            Text("Live")
                .font(.caption2.bold())
                .foregroundStyle(Color.accentGreen)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: false)) {
                isPulsing = true
            }
        }
    }
}

#Preview {
    LiveIndicator()
        .padding()
        .background(Color.bgPrimary)
}
