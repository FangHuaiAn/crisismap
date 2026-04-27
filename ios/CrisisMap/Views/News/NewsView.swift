import SwiftData
import SwiftUI

struct NewsView: View {
    @Environment(NewsViewModel.self) private var newsVM
    @Environment(\.modelContext) private var modelContext

    @State private var didBootstrap = false

    var body: some View {
        @Bindable var vm = newsVM

        NavigationStack {
            VStack(spacing: 12) {
                filterBar

                if vm.isOffline {
                    offlineBanner
                }

                if vm.isLoading && vm.allClusters.isEmpty {
                    Spacer()
                    ProgressView()
                        .tint(Color.accentBlue)
                    Spacer()
                } else if let error = vm.error, vm.allClusters.isEmpty {
                    ContentUnavailableView {
                        Label("News Unavailable", systemImage: "newspaper.fill")
                    } description: {
                        Text(error)
                    }
                } else if vm.filteredClusters.isEmpty {
                    ContentUnavailableView {
                        Label("No Clusters", systemImage: "tray")
                    } description: {
                        Text("Try another region/topic filter.")
                    }
                } else {
                    List(vm.filteredClusters) { cluster in
                        NavigationLink {
                            ClusterDetailView(cluster: cluster)
                        } label: {
                            ClusterRow(cluster: cluster)
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            .padding(.top, 8)
            .background(Color.bgPrimary)
            .navigationTitle("News")
            .searchable(text: $vm.searchText, prompt: "Search clusters")
            .refreshable {
                await refreshNow()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task { await refreshNow() }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        }
        .task {
            guard !didBootstrap else { return }
            didBootstrap = true
            newsVM.setModelContext(modelContext)
            await refreshNow()
        }
    }

    private var offlineBanner: some View {
        Label("Showing cached news while live sources are unavailable.", systemImage: "wifi.slash")
            .font(.caption)
            .foregroundStyle(Color.accentOrange)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.bgSecondary)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .padding(.horizontal, 12)
    }

    private var filterBar: some View {
        @Bindable var vm = newsVM

        return ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                Menu {
                    ForEach(Region.allCases, id: \.self) { region in
                        Button(region.label) {
                            vm.selectedRegion = region
                        }
                    }
                } label: {
                    Label(vm.selectedRegion.label, systemImage: "globe")
                        .font(.caption)
                        .foregroundStyle(Color.textPrimary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.bgSecondary)
                        .clipShape(Capsule())
                }

                Menu {
                    Button("All Topics") {
                        vm.selectedTopic = nil
                    }

                    ForEach(vm.availableTopics, id: \.self) { topic in
                        Button(topic) {
                            vm.selectedTopic = topic
                        }
                    }
                } label: {
                    Label(vm.selectedTopic ?? "All Topics", systemImage: "tag")
                        .font(.caption)
                        .foregroundStyle(Color.textPrimary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.bgSecondary)
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal, 12)
        }
    }

    private func refreshNow() async {
        await newsVM.refresh()
    }
}
