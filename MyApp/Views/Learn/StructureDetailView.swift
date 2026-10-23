import SwiftUI

struct StructureDetailView: View {
    // matching the organ keeps the detail page and AR destination consistent
    @Environment(AppState.self) private var appState
    let structure: AnatomyStructure

    private var organ: Organ {
        SampleAnatomyData.organs.first { $0.title == structure.organTitle }
            ?? SampleAnatomyData.heart
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                StructureHeader(structure: structure, organ: organ)
                StructureInformation(title: "STRUCTURE", text: structure.pathway)
                StructureInformation(title: "FUNCTION", text: structure.functionDescription)
                StructureTags(tags: structure.tags)
                StructureActions(
                    organID: organ.id,
                    isSaved: appState.isFavourite(structure.id),
                    toggleSaved: {
                        appState.toggleFavourite(structure.id)
                    }
                )
            }
            .padding()
        }
        .navigationTitle(structure.title)
        .navigationBarTitleDisplayMode(.inline)
        .anatomyScreenBackground()
    }
}

private struct StructureHeader: View {
    // icon and colour follow the structure's parent organ
    let structure: AnatomyStructure
    let organ: Organ

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(structure.organTitle) → \(structure.topic)")
                .font(.subheadline)
                .foregroundStyle(AnatomyTheme.organColor(for: organ.id))

            Image(systemName: organ.symbolName)
                .font(.system(size: 90))
                .foregroundStyle(AnatomyTheme.organColor(for: organ.id))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)

            Text(structure.title)
                .font(.largeTitle)
                .fontWeight(.bold)
        }
    }
}

private struct StructureInformation: View {
    let title: String
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(AnatomyTheme.teal)
            Text(text)
                .font(.body)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .anatomyCard()
    }
}

private struct StructureTags: View {
    let tags: [String]

    var body: some View {
        HStack {
            ForEach(tags, id: \.self) { tag in
                Text(tag)
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 7)
                    .background(AnatomyTheme.heart.opacity(0.12), in: Capsule())
            }
        }
    }
}

private struct StructureActions: View {
    // saving updates AppState; AR receives the matching organ ID
    let organID: String
    let isSaved: Bool
    let toggleSaved: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            PrimaryButton(
                isSaved ? "Remove from Saved" : "Save Structure",
                systemImage: isSaved ? "bookmark.slash.fill" : "bookmark.fill",
                action: toggleSaved
            )

            NavigationLink {
                ARPlaceholderView(initialOrganID: organID)
            } label: {
                Label("View in AR", systemImage: "arkit")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 48)
                    .foregroundStyle(AnatomyTheme.teal)
                    .overlay {
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(AnatomyTheme.teal)
                    }
            }
        }
    }
}
