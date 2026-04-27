import SwiftData
import SwiftUI

@main
struct CrisisMapApp: App {
    @State private var eventsVM = EventsViewModel()
    @State private var marketsVM = MarketsViewModel()
    @State private var actorsVM = ActorsViewModel()
    @State private var researchVM = ResearchViewModel()
    @State private var newsVM = NewsViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(eventsVM)
                .environment(marketsVM)
                .environment(actorsVM)
                .environment(researchVM)
                .environment(newsVM)
                .preferredColorScheme(.dark)
        }
        .modelContainer(for: [CachedWeekly.self, CachedMention.self, CachedMentionSnapshot.self, CachedNewsBatch.self])
    }
}
