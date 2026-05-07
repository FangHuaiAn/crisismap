import SwiftUI

struct SourceTransparencySheet: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("sourceTransparency.intro")
                        .foregroundStyle(Color.textPrimary)
                }

                sourceSection(
                    titleKey: "sourceTransparency.news.title",
                    descriptionKey: "sourceTransparency.news.description",
                    sources: SourceTransparencyContent.newsSources
                )

                sourceSection(
                    titleKey: "sourceTransparency.research.title",
                    descriptionKey: "sourceTransparency.research.description",
                    sources: SourceTransparencyContent.researchSources
                )

                Section("sourceTransparency.organized.title") {
                    Text("sourceTransparency.organized.description")
                        .foregroundStyle(Color.textPrimary)
                }

                Section("sourceTransparency.limits.title") {
                    ForEach(SourceTransparencyContent.limitations) { limitation in
                        Label {
                            Text(LocalizedStringKey(limitation.localizationKey))
                                .foregroundStyle(Color.textPrimary)
                        } icon: {
                            Image(systemName: "exclamationmark.triangle")
                                .foregroundStyle(Color.accentOrange)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("sourceTransparency.title")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("common.done") {
                        dismiss()
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func sourceSection(
        titleKey: LocalizedStringKey,
        descriptionKey: LocalizedStringKey,
        sources: [SourceTransparencyContent.Source]
    ) -> some View {
        Section(titleKey) {
            Text(descriptionKey)
                .foregroundStyle(Color.textPrimary)

            ForEach(sources) { source in
                VStack(alignment: .leading, spacing: 4) {
                    Text(source.name)
                        .foregroundStyle(Color.textPrimary)

                    if let detailLocalizationKey = source.detailLocalizationKey {
                        Text(LocalizedStringKey(detailLocalizationKey))
                            .font(.caption)
                            .foregroundStyle(Color.textSecondary)
                    }
                }
                .padding(.vertical, 2)
            }
        }
    }
}

#Preview {
    SourceTransparencySheet()
}
