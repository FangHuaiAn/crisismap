import SwiftData
import SwiftUI

enum AppTab: Int, CaseIterable, Identifiable, Sendable {
    case map
    case feed
    case dashboard
    case news
    case research

    static let mvpVisible: [AppTab] = [.map, .news, .research]

    var id: Self { self }

    var title: LocalizedStringKey {
        switch self {
        case .map:       "tab.map"
        case .feed:      "tab.feed"
        case .dashboard: "tab.dashboard"
        case .news:      "news.title"
        case .research:  "tab.research"
        }
    }

    var systemImage: String {
        switch self {
        case .map:       "map.fill"
        case .feed:      "list.bullet"
        case .dashboard: "chart.bar.fill"
        case .news:      "newspaper.fill"
        case .research:  "book.fill"
        }
    }
}

struct ContentView: View {
    @State private var selectedTab: AppTab = .map
    @Environment(ResearchViewModel.self) private var researchVM
    @Environment(NewsViewModel.self) private var newsVM
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(AppTab.mvpVisible) { tab in
                tabContent(for: tab)
                    .tabItem {
                        Label(tab.title, systemImage: tab.systemImage)
                    }
                    .tag(tab)
            }
        }
        .tint(Color.accentBlue)
        .onAppear {
            researchVM.setModelContext(modelContext)
            newsVM.setModelContext(modelContext)
        }
    }

    @ViewBuilder
    private func tabContent(for tab: AppTab) -> some View {
        switch tab {
        case .map:
            CrisisMapView()
        case .feed:
            EventListView()
        case .dashboard:
            DashboardView()
        case .news:
            NewsView()
        case .research:
            ResearchView()
        }
    }
}

#Preview {
    ContentView()
        .environment(EventsViewModel())
        .environment(MarketsViewModel())
        .environment(ActorsViewModel())
        .environment(ResearchViewModel())
        .environment(NewsViewModel(eventProvider: EmptyNewsEventProvider()))
        .modelContainer(for: [CachedWeekly.self, CachedMention.self, CachedMentionSnapshot.self, CachedNewsBatch.self], inMemory: true)
}
