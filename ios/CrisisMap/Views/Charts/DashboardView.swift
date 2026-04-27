import SwiftUI

struct DashboardView: View {
    @Environment(EventsViewModel.self) private var eventsVM
    @Environment(MarketsViewModel.self) private var marketsVM
    @Environment(ActorsViewModel.self) private var actorsVM

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    ThreatOverviewCard(events: eventsVM.filteredEvents)
                    CategoryBreakdownCard(events: eventsVM.filteredEvents)
                    MarketIndicatorsCard(indicators: marketsVM.indicators)
                    PolymarketCard(contracts: marketsVM.contracts)
                    KeyActorsCard(actors: actorsVM.actors)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
            }
            .background(Color.bgPrimary)
            .navigationTitle("nav.dashboard")
            .navigationBarTitleDisplayMode(.inline)
            .refreshable {
                async let e: () = eventsVM.refresh()
                async let m: () = marketsVM.refresh()
                async let a: () = actorsVM.refresh()
                _ = await (e, m, a)
            }
        }
        .onAppear {
            eventsVM.startPolling()
            marketsVM.startPolling()
            actorsVM.startPolling()
        }
        .onDisappear {
            marketsVM.stopPolling()
            actorsVM.stopPolling()
        }
    }
}
