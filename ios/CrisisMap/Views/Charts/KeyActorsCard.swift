import SwiftUI

struct KeyActorsCard: View {
    let actors: [ActorStatus]

    var body: some View {
        DashboardCard(title: String(localized: "chart.keyActors"), icon: "person.3.fill") {
            if actors.isEmpty {
                Text("Loading...")
                    .font(.caption)
                    .foregroundStyle(Color.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
            } else {
                VStack(spacing: 6) {
                    ForEach(actors.prefix(10)) { actor in
                        actorRow(actor)
                    }
                }
            }
        }
    }

    private func actorRow(_ actor: ActorStatus) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 8) {
                Text(actor.flag)
                    .font(.title3)

                VStack(alignment: .leading, spacing: 1) {
                    Text(actor.name)
                        .font(.caption.bold())
                        .foregroundStyle(Color.textPrimary)
                    Text(actor.role)
                        .font(.system(size: 10))
                        .foregroundStyle(Color.textSecondary)
                }

                Spacer()

                Text("\(actor.eventCount)")
                    .font(.caption2.bold())
                    .foregroundStyle(Color.accentBlue)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.accentBlue.opacity(0.15))
                    .clipShape(Capsule())
            }

            if let statement = actor.lastStatement {
                HStack(alignment: .top, spacing: 4) {
                    Image(systemName: "quote.opening")
                        .font(.system(size: 8))
                        .foregroundStyle(Color.textSecondary)
                    Text(statement)
                        .font(.system(size: 10))
                        .foregroundStyle(Color.textSecondary)
                        .lineLimit(2)
                }
                .padding(.leading, 36)
            }
        }
        .padding(8)
        .background(Color.bgTertiary.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}
