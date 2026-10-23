import SwiftUI

struct ProgressDashboardView: View {
    // every chart is calculated from saved lessons and quiz results
    @Environment(AppState.self) private var appState

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 24) {
                SectionTitle(
                    "See what you know",
                    eyebrow: "LEARNING PULSE",
                    subtitle: "Your progress becomes visible as every organ fills with colour."
                )
                ProgressHero(appState: appState)

                Text("Organ mastery")
                    .font(.title2.weight(.bold))
                    .accessibilityAddTraits(.isHeader)

                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: 360), spacing: 20)],
                    spacing: 20
                ) {
                    ForEach(SampleAnatomyData.organs) { organ in
                        MasteryCard(organ: organ, appState: appState)
                    }
                }
            }
            .adaptiveContentWidth(1_050)
            .padding(20)
            .padding(.bottom, 24)
        }
        .navigationTitle("Progress")
        .navigationBarTitleDisplayMode(.inline)
        .anatomyScreenBackground()
    }
}

private struct ProgressHero: View {
    // combines overall completion with the learner's main totals
    let appState: AppState

    private var overallProgress: Double {
        let organs = SampleAnatomyData.organs
        guard !organs.isEmpty else { return 0 }
        return organs.map(appState.progress(for:)).reduce(0, +) / Double(organs.count)
    }

    private var completedLessonCount: Int {
        SampleAnatomyData.organs
            .map(appState.completedLessonCount(for:))
            .reduce(0, +)
    }

    var body: some View {
        HStack(spacing: 18) {
            ZStack {
                Circle()
                    .stroke(.white.opacity(0.08), lineWidth: 12)
                Circle()
                    .trim(from: 0, to: overallProgress)
                    .stroke(
                        AngularGradient(colors: [AnatomyTheme.teal, AnatomyTheme.brain], center: .center),
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                VStack(spacing: 1) {
                    Text(overallProgress, format: .percent.precision(.fractionLength(0)))
                        .font(.title2.weight(.bold))
                    Text("overall").font(.caption).foregroundStyle(AnatomyTheme.textSecondary)
                }
            }
            .frame(width: 118, height: 118)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Overall progress")
            .accessibilityValue("\(Int((overallProgress * 100).rounded())) percent")

            VStack(alignment: .leading, spacing: 14) {
                ProgressMetric(
                    value: "\(appState.favouriteStructureIDs.count)",
                    label: "Saved structures",
                    icon: "bookmark.fill"
                )
                ProgressMetric(
                    value: "\(appState.quizAverage)%",
                    label: "Quiz average",
                    icon: "checkmark.seal.fill"
                )
                ProgressMetric(
                    value: "\(completedLessonCount)",
                    label: "Lessons complete",
                    icon: "book.fill"
                )
            }
        }
        .anatomyCard()
    }
}

private struct ProgressMetric: View {
    let value: String
    let label: String
    let icon: String

    var body: some View {
        HStack {
            Image(systemName: icon).foregroundStyle(AnatomyTheme.teal).frame(width: 22)
            VStack(alignment: .leading, spacing: 1) {
                Text(value).font(.headline)
                Text(label).font(.caption).foregroundStyle(AnatomyTheme.textSecondary)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label), \(value)")
    }
}

private struct MasteryCard: View {
    // passes one organ's live values into the reusable progress graphic
    let organ: Organ
    let appState: AppState

    var body: some View {
        HStack(spacing: 8) {
            OrganProgressView(
                title: organ.title,
                organID: organ.id,
                progress: appState.progress(for: organ),
                color: AnatomyTheme.organColor(for: organ.id),
                completedLessons: appState.completedLessonCount(for: organ),
                totalLessons: organ.lessons.count,
                bestQuizScore: appState.bestQuizScore(for: organ.id)
            )
        }
        .anatomyCard()
    }
}
