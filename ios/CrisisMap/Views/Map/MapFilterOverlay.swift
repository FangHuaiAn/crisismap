import SwiftUI

struct MapFilterOverlay: View {
    @Environment(EventsViewModel.self) private var viewModel

    @State private var isExpanded = false

    var body: some View {
        @Bindable var vm = viewModel

        VStack(alignment: .leading, spacing: 0) {
            // Toggle button
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "line.3.horizontal.decrease")
                        .font(.system(size: 14, weight: .semibold))
                    if viewModel.activeFilterCount > 0 {
                        Text("\(viewModel.activeFilterCount)")
                            .font(.caption2.bold())
                            .foregroundStyle(.white)
                            .frame(width: 16, height: 16)
                            .background(Color.accentBlue)
                            .clipShape(Circle())
                    }
                }
                .foregroundStyle(Color.textPrimary)
                .padding(10)
                .background(Color.bgSecondary.opacity(0.9))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.border, lineWidth: 1)
                )
            }

            if isExpanded {
                VStack(alignment: .leading, spacing: 10) {
                    // Region
                    Text("filter.region")
                        .font(.caption.bold())
                        .foregroundStyle(Color.textSecondary)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(Region.allCases, id: \.self) { region in
                                FilterChip(
                                    label: region.label,
                                    isActive: viewModel.selectedRegion == region
                                ) {
                                    vm.selectedRegion = region
                                }
                            }
                        }
                    }

                    // Levels
                    Text("filter.level")
                        .font(.caption.bold())
                        .foregroundStyle(Color.textSecondary)

                    HStack(spacing: 6) {
                        ForEach(ThreatLevel.allCases, id: \.self) { level in
                            FilterChip(
                                label: level.label,
                                isActive: viewModel.selectedLevels.contains(level),
                                activeColor: level.color
                            ) {
                                if vm.selectedLevels.contains(level) {
                                    vm.selectedLevels.remove(level)
                                } else {
                                    vm.selectedLevels.insert(level)
                                }
                            }
                        }
                    }

                    // Categories
                    Text("filter.category")
                        .font(.caption.bold())
                        .foregroundStyle(Color.textSecondary)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(EventCategory.allCases, id: \.self) { cat in
                                FilterChip(
                                    label: cat.label,
                                    isActive: viewModel.selectedCategories.contains(cat)
                                ) {
                                    if vm.selectedCategories.contains(cat) {
                                        vm.selectedCategories.remove(cat)
                                    } else {
                                        vm.selectedCategories.insert(cat)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(12)
                .background(Color.bgSecondary.opacity(0.95))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.border, lineWidth: 1)
                )
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}

private struct FilterChip: View {
    let label: String
    let isActive: Bool
    var activeColor: Color = Color.accentBlue
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.caption2)
                .foregroundStyle(isActive ? .white : Color.textSecondary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(isActive ? activeColor.opacity(0.8) : Color.bgTertiary)
                .clipShape(Capsule())
        }
    }
}
