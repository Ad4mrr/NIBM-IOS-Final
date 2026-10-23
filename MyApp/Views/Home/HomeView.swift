import SwiftUI

struct HomeView: View {
    // next unfinished lesson
    @Environment(AppState.self) private var appState

    private var featuredLesson: (organ: Organ, lesson: AnatomyLesson) {
        for organ in SampleAnatomyData.organs {
            if let lesson = organ.lessons.first(where: { !appState.isLessonComplete($0.id) }) {
                return (organ, lesson)
            }
        }

        let organ = SampleAnatomyData.heart
        return (organ, organ.lessons[0])
    }

    private var hasStudyProgress: Bool {
        !appState.completedLessonIDs.isEmpty || !appState.bestQuizScores.isEmpty
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 28) {
                HomeHeader(learnerName: appState.learnerName)
                ContinueLearningHero(
                    organ: featuredLesson.organ,
                    lesson: featuredLesson.lesson,
                    progress: appState.progress(for: featuredLesson.organ),
                    hasStudyProgress: hasStudyProgress
                )
                QuickStatsRow(
                    completedLessonCount: appState.completedLessonIDs.count,
                    quizAverage: appState.quizAverage,
                    savedCount: appState.favouriteStructureIDs.count
                )
                OrganJourneySection(appState: appState)
            }
            .adaptiveContentWidth(900)
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
        }
        .toolbar(.hidden, for: .navigationBar)
        .anatomyScreenBackground()
    }
}

private struct HomeHeader: View {
    // greeting and profile link
    let learnerName: String

    var body: some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text("GOOD EVENING")
                    .font(.caption.weight(.bold))
                    .tracking(1.5)
                    .foregroundStyle(AnatomyTheme.teal)
                Text("Ready, \(learnerName)?")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(AnatomyTheme.textPrimary)
                    .accessibilityAddTraits(.isHeader)
            }

            Spacer()

            NavigationLink {
                SettingsView()
            } label: {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 42))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.white, AnatomyTheme.teal.opacity(0.45))
            }
            .accessibilityLabel("Profile and settings")
        }
        .padding(.top, 14)
    }
}

private struct ContinueLearningHero: View {
    // next lesson card
    let organ: Organ
    let lesson: AnatomyLesson
    let progress: Double
    let hasStudyProgress: Bool

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(AnatomyTheme.organGradient(for: organ.id))

            Circle()
                .fill(AnatomyTheme.heart.opacity(0.2))
                .frame(width: 240)
                .blur(radius: 30)
                .offset(x: 150, y: -60)

            OrganArtworkView(organID: organ.id, size: 220)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 36)
                .offset(y: -42)

            VStack(alignment: .leading, spacing: 14) {
                StatusBadge(
                    title: hasStudyProgress ? "CONTINUE" : "START HERE",
                    systemImage: "play.fill",
                    color: .white
                )

                Spacer()

                VStack(alignment: .leading, spacing: 5) {
                    Text(lesson.title)
                        .font(.title.weight(.bold))
                    Text("Lesson \(lesson.number) · \(lesson.durationMinutes) min · \(progress, format: .percent.precision(.fractionLength(0)))")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.72))
                }

                NavigationLink {
                    LessonDetailView(lesson: lesson)
                } label: {
                    Label(hasStudyProgress ? "Continue lesson" : "Start lesson", systemImage: "arrow.right")
                        .font(.headline)
                        .foregroundStyle(AnatomyTheme.background)
                        .padding(.horizontal, 18)
                        .frame(minHeight: 48)
                        .background(.white, in: Capsule())
                }
            }
            .padding(22)
        }
        .frame(height: 330)
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .stroke(.white.opacity(0.12))
        }
        .shadow(color: AnatomyTheme.heart.opacity(0.22), radius: 28, y: 18)
    }
}

private struct QuickStatsRow: View {
    // live app state values
    let completedLessonCount: Int
    let quizAverage: Int
    let savedCount: Int

    var body: some View {
        HStack(spacing: 12) {
            QuickStat(
                value: "\(completedLessonCount)",
                label: "lessons done",
                symbol: "checkmark.circle.fill",
                color: .orange
            )
            QuickStat(
                value: "\(quizAverage)%",
                label: "quiz avg.",
                symbol: "checkmark.seal.fill",
                color: AnatomyTheme.teal
            )
            QuickStat(
                value: "\(savedCount)",
                label: "saved",
                symbol: "bookmark.fill",
                color: AnatomyTheme.brain
            )
        }
    }
}

private struct QuickStat: View {
    let value: String
    let label: String
    let symbol: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: symbol)
                .foregroundStyle(color)
            Text(value)
                .font(.title2.weight(.bold))
            Text(label)
                .font(.caption)
                .foregroundStyle(AnatomyTheme.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .anatomyCard()
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(value), \(label)")
    }
}

private struct OrganJourneySection: View {
    // progress card per organ
    let appState: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionTitle(
                "Your anatomy journey",
                eyebrow: "PROGRESS",
                subtitle: "Every lesson colours in a little more."
            )

            ForEach(SampleAnatomyData.organs) { organ in
                NavigationLink {
                    OrganOverviewView(organ: organ)
                } label: {
                    HStack(spacing: 14) {
                        OrganArtworkView(organID: organ.id, size: 74, showsGlow: false)
                        VStack(alignment: .leading, spacing: 7) {
                            Text(organ.title)
                                .font(.headline)
                                .foregroundStyle(AnatomyTheme.textPrimary)
                            ProgressView(value: appState.progress(for: organ))
                                .tint(AnatomyTheme.organColor(for: organ.id))
                            Text(
                                appState.progress(for: organ),
                                format: .percent.precision(.fractionLength(0))
                            )
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(AnatomyTheme.organColor(for: organ.id))
                        }
                        Image(systemName: "chevron.right")
                            .foregroundStyle(AnatomyTheme.textSecondary)
                    }
                    .anatomyCard()
                }
                .buttonStyle(.plain)
            }
        }
    }
}
