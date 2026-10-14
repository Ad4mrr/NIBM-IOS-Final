import SwiftUI

struct HomeView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                HomeGreeting()
                ContinueLearningCard()
                HomeStatistics()
                RecommendedLessonCard()
                HomeProgressCard()
            }
            .padding()
        }
        .navigationTitle("Home")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    SettingsView()
                } label: {
                    Image(systemName: "person.crop.circle")
                }
                .accessibilityLabel("Profile and settings")
            }
        }
        .anatomyScreenBackground()
    }
}

private struct HomeGreeting: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Good evening,")
                .foregroundStyle(AnatomyTheme.textSecondary)

            Text("Ravindu")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(AnatomyTheme.textPrimary)
        }
    }
}

private struct ContinueLearningCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("CONTINUE LEARNING")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(AnatomyTheme.heart)

            HStack {
                Image(systemName: "heart.fill")
                    .font(.system(size: 42))
                    .foregroundStyle(AnatomyTheme.heart)

                VStack(alignment: .leading, spacing: 3) {
                    Text("Heart — Chambers")
                        .font(.headline)
                    Text("Lesson 3 of 5 • 60% complete")
                        .font(.subheadline)
                        .foregroundStyle(AnatomyTheme.textSecondary)
                }
            }

            NavigationLink {
                LessonDetailView(lesson: SampleAnatomyData.heartLessons[2])
            } label: {
                Text("Resume Lesson")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 46)
                    .foregroundStyle(.white)
                    .background(AnatomyTheme.heart, in: RoundedRectangle(cornerRadius: 12))
            }
        }
        .anatomyCard()
    }
}

private struct HomeStatistics: View {
    var body: some View {
        HStack(spacing: 10) {
            StatisticTile(value: "3", label: "Day Streak", icon: "flame.fill")
            StatisticTile(value: "80%", label: "Quiz Average", icon: "checkmark.seal.fill")
            StatisticTile(value: "5", label: "Saved", icon: "bookmark.fill")
        }
    }
}

private struct StatisticTile: View {
    let value: String
    let label: String
    let icon: String

    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: icon)
                .foregroundStyle(AnatomyTheme.teal)
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            Text(label)
                .font(.caption)
                .foregroundStyle(AnatomyTheme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, minHeight: 100)
        .anatomyCard()
    }
}

private struct RecommendedLessonCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Recommended Next")
                .font(.title2)
                .fontWeight(.bold)

            Label("Heart Valves", systemImage: "sparkles")
                .font(.headline)
                .foregroundStyle(AnatomyTheme.heart)

            Text("Continue your current topic and learn how valves keep blood moving forward.")
                .font(.subheadline)
                .foregroundStyle(AnatomyTheme.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .anatomyCard()
    }
}

private struct HomeProgressCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Your Heart Progress")
                .font(.title2)
                .fontWeight(.bold)

            OrganProgressView(
                title: "Heart",
                symbolName: "heart.fill",
                progress: 0.6,
                color: AnatomyTheme.heart,
                completedLessons: 3,
                totalLessons: 5,
                bestQuizScore: 80
            )
        }
        .anatomyCard()
    }
}
