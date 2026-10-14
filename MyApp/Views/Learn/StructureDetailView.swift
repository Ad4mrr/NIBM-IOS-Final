import SwiftUI

struct StructureDetailView: View {
    let structure: AnatomyStructure

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                StructureHeader(structure: structure)
                StructureInformation(title: "STRUCTURE", text: structure.pathway)
                StructureInformation(title: "FUNCTION", text: structure.functionDescription)
                StructureTags(tags: structure.tags)
                StructureActions()
            }
            .padding()
        }
        .navigationTitle(structure.title)
        .navigationBarTitleDisplayMode(.inline)
        .anatomyScreenBackground()
    }
}

private struct StructureHeader: View {
    let structure: AnatomyStructure

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(structure.organTitle) → \(structure.topic)")
                .font(.subheadline)
                .foregroundStyle(AnatomyTheme.heart)

            Image(systemName: "heart.circle.fill")
                .font(.system(size: 90))
                .foregroundStyle(AnatomyTheme.heart)
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
    var body: some View {
        VStack(spacing: 12) {
            PrimaryButton("Save Structure", systemImage: "bookmark") { }

            NavigationLink {
                ARPlaceholderView()
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
