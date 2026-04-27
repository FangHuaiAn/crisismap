import SwiftUI

struct FeedFilterBar: View {
    @Environment(EventsViewModel.self) private var viewModel

    var body: some View {
        @Bindable var vm = viewModel

        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                // Region menu
                Menu {
                    ForEach(Region.allCases, id: \.self) { region in
                        Button {
                            vm.selectedRegion = region
                        } label: {
                            HStack {
                                Text(region.label)
                                if viewModel.selectedRegion == region {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    chipLabel(
                        text: viewModel.selectedRegion.label,
                        isActive: viewModel.selectedRegion != .all,
                        icon: "globe"
                    )
                }

                // Level toggles
                ForEach(ThreatLevel.allCases, id: \.self) { level in
                    Button {
                        if vm.selectedLevels.contains(level) {
                            vm.selectedLevels.remove(level)
                        } else {
                            vm.selectedLevels.insert(level)
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Circle()
                                .fill(level.color)
                                .frame(width: 6, height: 6)
                            Text(level.label)
                                .font(.caption2)
                        }
                        .foregroundStyle(viewModel.selectedLevels.contains(level) ? .white : Color.textSecondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 5)
                        .background(viewModel.selectedLevels.contains(level) ? level.color.opacity(0.7) : Color.bgTertiary)
                        .clipShape(Capsule())
                    }
                }

                // Category menu
                Menu {
                    ForEach(EventCategory.allCases, id: \.self) { cat in
                        Button {
                            if vm.selectedCategories.contains(cat) {
                                vm.selectedCategories.remove(cat)
                            } else {
                                vm.selectedCategories.insert(cat)
                            }
                        } label: {
                            HStack {
                                Image(systemName: cat.icon)
                                Text(cat.label)
                                if viewModel.selectedCategories.contains(cat) {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    chipLabel(
                        text: viewModel.selectedCategories.isEmpty
                            ? "Category"
                            : "\(viewModel.selectedCategories.count) cats",
                        isActive: !viewModel.selectedCategories.isEmpty,
                        icon: "tag"
                    )
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private func chipLabel(text: String, isActive: Bool, icon: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 10))
            Text(text)
                .font(.caption2)
        }
        .foregroundStyle(isActive ? .white : Color.textSecondary)
        .padding(.horizontal, 8)
        .padding(.vertical, 5)
        .background(isActive ? Color.accentBlue.opacity(0.7) : Color.bgTertiary)
        .clipShape(Capsule())
    }
}
