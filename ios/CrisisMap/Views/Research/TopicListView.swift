import SwiftUI

struct TopicListView: View {
    @Environment(ResearchViewModel.self) private var viewModel
    let region: Region

    var topics: [(topic: String, count: Int)] {
        viewModel.topicsForRegion(region)
    }

    var body: some View {
        List {
            // "All Topics" row
            NavigationLink {
                ArticleListView(region: region, topic: nil)
            } label: {
                HStack {
                    Label(String(localized: "research.allTopics"), systemImage: "tray.full.fill")
                        .foregroundStyle(Color.textPrimary)
                    Spacer()
                    Text("\(viewModel.articlesFor(region: region, topic: nil).count)")
                        .foregroundStyle(Color.textSecondary)
                }
            }

            // Individual topics
            ForEach(topics, id: \.topic) { item in
                NavigationLink {
                    ArticleListView(region: region, topic: item.topic)
                } label: {
                    HStack {
                        Text(item.topic)
                            .foregroundStyle(Color.textPrimary)
                        Spacer()
                        Text("\(item.count)")
                            .foregroundStyle(Color.textSecondary)
                    }
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle(region.label)
    }
}
