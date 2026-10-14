import SwiftUI

struct AnatomyLibraryView: View {
    @State private var searchText = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("Explore Anatomy")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                NavigationLink {
                    SearchView()
                } label: {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        Text("Search organs, lessons and structures")
                        Spacer()
                    }
                    .foregroundStyle(AnatomyTheme.textSecondary)
                    .padding()
                    .background(AnatomyTheme.surface, in: RoundedRectangle(cornerRadius: 14))
                }

                ForEach(SampleAnatomyData.organs) { organ in
                    NavigationLink {
                        OrganOverviewView(organ: organ)
                    } label: {
                        OrganLibraryCard(organ: organ)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
        .navigationTitle("Learn")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    FavouritesView()
                } label: {
                    Image(systemName: "bookmark")
                }
                .accessibilityLabel("Saved structures")
            }
        }
        .anatomyScreenBackground()
    }
}

private struct OrganLibraryCard: View {
    let organ: Organ

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(organ.title.uppercased())
                        .font(.title2)
                        .fontWeight(.bold)
                    Text(organ.systemName)
                        .font(.subheadline)
                        .foregroundStyle(AnatomyTheme.textSecondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundStyle(.tertiary)
            }

            HStack(spacing: 8) {
                StatusBadge(title: "\(organ.lessons.count) lessons", systemImage: "book.closed")
                StatusBadge(title: "AR", systemImage: "arkit")
                StatusBadge(title: "Quiz", systemImage: "questionmark.circle")
            }

            OrganProgressView(
                title: organ.title,
                symbolName: organ.symbolName,
                progress: organ.progress,
                color: AnatomyTheme.organColor(for: organ.id),
                completedLessons: organ.completedLessonCount,
                totalLessons: organ.lessons.count,
                bestQuizScore: organ.bestQuizScore
            )
        }
        .anatomyCard()
    }
}

#Preview {
    NavigationStack {
        AnatomyLibraryView()
    }
}
