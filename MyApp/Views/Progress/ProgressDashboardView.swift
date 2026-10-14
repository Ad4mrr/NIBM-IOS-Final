import SwiftUI

struct ProgressDashboardView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                ProgressSummaryGrid()

                Text("Organ Progress")
                    .font(.title2)
                    .fontWeight(.bold)

                ForEach(SampleAnatomyData.organs) { organ in
                    OrganProgressView(
                        title: organ.title,
                        symbolName: organ.symbolName,
                        progress: organ.progress,
                        color: AnatomyTheme.organColor(for: organ.id),
                        completedLessons: organ.completedLessonCount,
                        totalLessons: organ.lessons.count,
                        bestQuizScore: organ.bestQuizScore
                    )
                    .anatomyCard()
                }
            }
            .padding()
        }
        .navigationTitle("Your Progress")
        .anatomyScreenBackground()
    }
}

private struct ProgressSummaryGrid: View {
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ProgressSummaryTile(value: "3", label: "Topics Studied", icon: "book.fill")
            ProgressSummaryTile(value: "60%", label: "Quiz Average", icon: "checkmark.seal.fill")
            ProgressSummaryTile(value: "3", label: "Saved Structures", icon: "bookmark.fill")
            ProgressSummaryTile(value: "3 days", label: "Study Streak", icon: "flame.fill")
        }
    }
}

private struct ProgressSummaryTile: View {
    let value: String
    let label: String
    let icon: String

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .foregroundStyle(AnatomyTheme.teal)
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            Text(label)
                .font(.caption)
                .foregroundStyle(AnatomyTheme.textSecondary)
        }
        .frame(maxWidth: .infinity, minHeight: 100)
        .anatomyCard()
    }
}

#Preview {
    NavigationStack {
        ProgressDashboardView()
    }
}
