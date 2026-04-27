import SwiftUI

struct EventListView: View {
    @Environment(EventsViewModel.self) private var viewModel

    @State private var selectedTab = 0

    var body: some View {
        @Bindable var vm = viewModel

        NavigationStack {
            VStack(spacing: 0) {
                // Filter bar
                FeedFilterBar()
                    .padding(.vertical, 8)

                // Tab picker: Feed / Timeline
                Picker("View", selection: $selectedTab) {
                    Text("tab.feed").tag(0)
                    Text("tab.timeline").tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 16)
                .padding(.bottom, 8)

                // Content
                if viewModel.isLoading && viewModel.events.isEmpty {
                    Spacer()
                    ProgressView()
                        .tint(Color.accentBlue)
                    Spacer()
                } else if let error = viewModel.error, viewModel.events.isEmpty {
                    Spacer()
                    errorView(error)
                    Spacer()
                } else if selectedTab == 0 {
                    feedList
                } else {
                    timelineList
                }
            }
            .background(Color.bgPrimary)
            .navigationTitle("nav.events")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $vm.searchText, prompt: "filter.search")
            .refreshable {
                await viewModel.refresh()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Text("\(viewModel.filteredEvents.count)")
                        .font(.caption.bold())
                        .foregroundStyle(Color.accentBlue)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.accentBlue.opacity(0.15))
                        .clipShape(Capsule())
                }
            }
        }
        .onAppear { viewModel.startPolling() }
        .onDisappear { viewModel.stopPolling() }
    }

    // MARK: - Feed List

    private var feedList: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(viewModel.filteredEvents) { event in
                    EventRow(event: event)
                        .onTapGesture { selectEvent(event) }
                }
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 16)
        }
    }

    // MARK: - Timeline

    private var timelineList: some View {
        let groups = groupedByHour(viewModel.filteredEvents)

        return ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(groups, id: \.hour) { group in
                    // Hour header
                    Text(group.hour)
                        .font(.caption.bold())
                        .foregroundStyle(Color.accentBlue)
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                        .padding(.bottom, 4)

                    ForEach(group.events) { event in
                        HStack(spacing: 8) {
                            // Timeline line + dot
                            VStack(spacing: 0) {
                                Rectangle()
                                    .fill(Color.border)
                                    .frame(width: 1)
                                Circle()
                                    .fill(event.level.color)
                                    .frame(width: 8, height: 8)
                                Rectangle()
                                    .fill(Color.border)
                                    .frame(width: 1)
                            }
                            .frame(width: 12)

                            // Content
                            VStack(alignment: .leading, spacing: 2) {
                                HStack(spacing: 4) {
                                    CategoryIcon(category: event.category, size: 10)
                                    Text(event.title)
                                        .font(.caption)
                                        .foregroundStyle(Color.textPrimary)
                                        .lineLimit(1)
                                    Spacer()
                                    Text(timeOnly(event.timestamp))
                                        .font(.system(size: 10, design: .monospaced))
                                        .foregroundStyle(Color.textSecondary)
                                }
                            }
                            .padding(.vertical, 6)
                        }
                        .padding(.horizontal, 16)
                        .onTapGesture { selectEvent(event) }
                    }
                }
            }
            .padding(.bottom, 16)
        }
    }

    // MARK: - Helpers

    private func selectEvent(_ event: CrisisEvent) {
        viewModel.selectedEventId = event.id
    }

    private func errorView(_ message: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle")
                .font(.title)
                .foregroundStyle(Color.accentOrange)
            Text(message)
                .font(.caption)
                .foregroundStyle(Color.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }

    private struct HourGroup {
        let hour: String
        let events: [CrisisEvent]
    }

    private func groupedByHour(_ events: [CrisisEvent]) -> [HourGroup] {
        let sorted = events.sorted { parseISO($0.timestamp) > parseISO($1.timestamp) }
        let grouped = Dictionary(grouping: sorted) { event -> String in
            let date = parseISO(event.timestamp)
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, HH:00"
            formatter.timeZone = .current
            return formatter.string(from: date)
        }
        return grouped
            .map { HourGroup(hour: $0.key, events: $0.value) }
            .sorted { $0.hour > $1.hour }
    }

    private func timeOnly(_ iso: String) -> String {
        let date = parseISO(iso)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = .current
        return formatter.string(from: date)
    }
}
