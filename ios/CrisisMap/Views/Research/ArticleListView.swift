import SwiftUI

struct ArticleListView: View {
    @Environment(ResearchViewModel.self) private var viewModel
    let region: Region
    let topic: String?

    var articles: [ThinkTankArticle] {
        viewModel.articlesFor(region: region, topic: topic)
    }

    var body: some View {
        List(articles) { article in
            if let url = URL(string: article.url) {
                Link(destination: url) {
                    ArticleRow(article: article)
                }
            } else {
                ArticleRow(article: article)
            }
        }
        .listStyle(.plain)
        .navigationTitle(topic ?? region.label)
    }
}
