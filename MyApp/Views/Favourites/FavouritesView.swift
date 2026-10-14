import SwiftUI

struct FavouritesView: View {
    @State private var showEmptyState = false

    var body: some View {
        VStack {
            if showEmptyState {
                EmptyFavouritesView()
            } else {
                List(SampleAnatomyData.favourites) { favourite in
                    NavigationLink {
                        StructureDetailView(structure: SampleAnatomyData.aorticValve)
                    } label: {
                        FavouriteRow(favourite: favourite)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Saved Structures")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(showEmptyState ? "Show Saved" : "Show Empty") {
                    showEmptyState.toggle()
                }
            }
        }
    }
}

private struct FavouriteRow: View {
    let favourite: SavedStructure

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: "bookmark.fill")
                .foregroundStyle(AnatomyTheme.teal)
                .frame(width: 42, height: 42)
                .background(AnatomyTheme.teal.opacity(0.12), in: RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading) {
                Text(favourite.title)
                    .font(.headline)
                Text("\(favourite.organTitle) • \(favourite.topic)")
                    .font(.subheadline)
                    .foregroundStyle(AnatomyTheme.textSecondary)
            }
        }
        .padding(.vertical, 5)
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
