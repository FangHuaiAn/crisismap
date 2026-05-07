import SwiftUI

struct ResearchView: View {
    @Environment(ResearchViewModel.self) private var viewModel
    @State private var isShowingSourceTransparency = false

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.articles.isEmpty {
                    ProgressView(String(localized: "research.loading"))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = viewModel.error, viewModel.articles.isEmpty {
                    ContentUnavailableView {
                        Label(String(localized: "research.error"), systemImage: "exclamationmark.triangle")
                    } description: {
                        Text(error)
                    } actions: {
                        Button(String(localized: "research.retry")) {
                            Task { await viewModel.loadData() }
                        }
                    }
                } else {
                    regionList
                }
            }
            .navigationTitle(String(localized: "research.title"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingSourceTransparency = true
                    } label: {
                        Image(systemName: "info.circle")
                    }
                    .accessibilityLabel(Text("sourceTransparency.button"))
                }

                if viewModel.isOffline {
                    ToolbarItem(placement: .status) {
                        Label(String(localized: "research.offline"), systemImage: "wifi.slash")
                            .font(.caption)
                            .foregroundStyle(Color.accentYellow)
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingSourceTransparency) {
            SourceTransparencySheet()
        }
        .task {
            if viewModel.articles.isEmpty {
                await viewModel.loadData()
            }
        }
    }

    private var regionList: some View {
        List(viewModel.regionsWithCounts, id: \.region) { item in
            NavigationLink {
                TopicListView(region: item.region)
            } label: {
                HStack {
                    Text(item.region.label)
                        .foregroundStyle(Color.textPrimary)
                    Spacer()
                    Text("\(item.count)")
                        .font(.subheadline)
                        .foregroundStyle(Color.textSecondary)
                }
            }
        }
        .listStyle(.plain)
        .refreshable {
            await viewModel.loadData()
        }
    }
}
