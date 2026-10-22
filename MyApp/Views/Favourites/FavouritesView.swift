import SwiftUI

struct FavouritesView: View {
    @Environment(AppState.self) private var appState

    private var visibleFavourites: [AnatomyStructure] {
        SampleAnatomyData.structures.filter {
            appState.isFavourite($0.id)
        }
    }

    var body: some View {
        VStack {
            if visibleFavourites.isEmpty {
                EmptyFavouritesView()
            } else {
                List(visibleFavourites) { structure in
                    NavigationLink {
                        StructureDetailView(structure: structure)
                    } label: {
                        FavouriteRow(structure: structure)
                    }
                    .swipeActions {
                        Button("Remove", systemImage: "bookmark.slash", role: .destructive) {
                            appState.toggleFavourite(structure.id)
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Saved Structures")
        .preferredColorScheme(.dark)
    }
}

private struct FavouriteRow: View {
    let structure: AnatomyStructure

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: "bookmark.fill")
                .foregroundStyle(AnatomyTheme.teal)
                .frame(width: 42, height: 42)
                .background(AnatomyTheme.teal.opacity(0.12), in: RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading) {
                Text(structure.title)
                    .font(.headline)
                Text("\(structure.organTitle) • \(structure.topic)")
                    .font(.subheadline)
                    .foregroundStyle(AnatomyTheme.textSecondary)
            }
        }
        .padding(.vertical, 5)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(structure.title), \(structure.organTitle), \(structure.topic)")
    }
}

private struct EmptyFavouritesView: View {
    var body: some View {
        ContentUnavailableView {
            Label("Saved Structures", systemImage: "bookmark")
        } description: {
            Text("Build your revision list. Save structures from lessons or AR and revisit them anytime.")
        }
    }
}
