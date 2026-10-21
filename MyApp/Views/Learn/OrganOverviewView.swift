import SwiftUI

struct OrganOverviewView: View {
    @Environment(AppState.self) private var appState
    let organ: Organ

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 24) {
                OrganOverviewHero(organ: organ, progress: appState.progress(for: organ))
                LessonPathSection(organ: organ, appState: appState)
                QuizLaunchCard(organTitle: organ.title, organID: organ.id)
            }
            .adaptiveContentWidth(960)
            .padding(.bottom, 28)
        }
        .ignoresSafeArea(edges: .top)
        .toolbarBackground(.hidden, for: .navigationBar)
        .anatomyScreenBackground()
    }
}

private struct OrganOverviewHero: View {
    let organ: Organ
    let progress: Double

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Rectangle()
                .fill(AnatomyTheme.organGradient(for: organ.id))
            OrganArtworkView(organID: organ.id, size: 300)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 48)
                .offset(y: -30)

            LinearGradient(
                colors: [.clear, AnatomyTheme.background.opacity(0.95)],
                startPoint: .center,
                endPoint: .bottom
            )

            VStack(alignment: .leading, spacing: 10) {
                StatusBadge(title: organ.systemName.uppercased(), systemImage: "sparkles", color: .white)
                Spacer()
                Text(organ.title)
                    .font(.system(.largeTitle, design: .rounded, weight: .bold))
                    .accessibilityAddTraits(.isHeader)
                Text(organ.description)
                    .foregroundStyle(.white.opacity(0.72))
                    .frame(maxWidth: 270, alignment: .leading)
                ProgressView(value: progress)
                    .tint(AnatomyTheme.organColor(for: organ.id))
                    .frame(maxWidth: 260)
                    .accessibilityLabel("\(organ.title) lesson progress")
                    .accessibilityValue("\(Int((progress * 100).rounded())) percent")
                Text(progress, format: .percent.precision(.fractionLength(0)))
                    .font(.headline)
                    .foregroundStyle(AnatomyTheme.organColor(for: organ.id))
            }
            .padding(20)
            .padding(.top, 42)
        }
        .frame(height: 430)
    }
}

private struct LessonPathSection: View {
    let organ: Organ
    let appState: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionTitle(
                "Learning path",
                eyebrow: "\(organ.lessons.count) SHORT LESSONS",
                subtitle: "Move from foundations to confident recall."
            )

            ForEach(organ.lessons) { lesson in
                NavigationLink {
                    LessonDetailView(lesson: lesson)
                } label: {
                    ModernLessonRow(
                        lesson: lesson,
                        color: AnatomyTheme.organColor(for: organ.id),
                        isCompleted: appState.isLessonComplete(lesson.id)
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 20)
    }
}

private struct ModernLessonRow: View {
    let lesson: AnatomyLesson
    let color: Color
    let isCompleted: Bool

    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle().fill(color.opacity(0.14))
                Text(lesson.number, format: .number.precision(.integerLength(2)))
                    .font(.caption.monospaced().weight(.bold))
                    .foregroundStyle(color)
            }
            .frame(width: 48, height: 48)

            VStack(alignment: .leading, spacing: 4) {
                Text(lesson.title).font(.headline).foregroundStyle(.white)
                Text("\(lesson.durationMinutes) min · \(lesson.structureCount) structures")
                    .font(.caption)
                    .foregroundStyle(AnatomyTheme.textSecondary)
            }
            Spacer()
            Image(systemName: isCompleted ? "checkmark.circle.fill" : lesson.status.symbolName)
                .foregroundStyle(isCompleted ? color : AnatomyTheme.textSecondary)
        }
        .anatomyCard()
    }
}

private struct QuizLaunchCard: View {
    let organTitle: String
    let organID: String

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 28)
                .fill(AnatomyTheme.organGradient(for: organID))
            OrganArtworkView(organID: organID, size: 130, showsGlow: false)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 30)
                .offset(y: 30)
                .opacity(0.65)
            VStack(alignment: .leading, spacing: 10) {
                Label("KNOWLEDGE CHECK", systemImage: "bolt.fill")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(AnatomyTheme.organColor(for: organID))
                Text("\(organTitle) quiz")
                    .font(.title2.weight(.bold))
                Text("Five quick questions · about 3 minutes")
                    .font(.subheadline)
                    .foregroundStyle(AnatomyTheme.textSecondary)
                NavigationLink {
                    QuizQuestionView(
                        organID: organID,
                        questions: SampleAnatomyData.quizQuestionsByOrganID[organID] ?? []
                    )
                } label: {
                    Text("Start quiz")
                        .font(.headline)
                        .foregroundStyle(AnatomyTheme.background)
                        .padding(.horizontal, 18)
                        .frame(minHeight: 44)
                        .background(.white, in: Capsule())
                }
            }
            .padding(22)
        }
        .frame(minHeight: 190)
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .padding(.horizontal, 20)
    }
}
