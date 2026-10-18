import SwiftUI

struct LessonDetailView: View {
    @Environment(AppState.self) private var appState
    let lesson: AnatomyLesson

    private var organID: String {
        lesson.id.components(separatedBy: "-").first ?? "heart"
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 24) {
                LessonHeader(lesson: lesson, organID: organID)
                MotionLessonCard(organID: organID)
                LessonTakeaway(text: lesson.keyTakeaway, color: AnatomyTheme.organColor(for: organID))
                LessonConcepts(organID: organID)
                StudySessionCard(lesson: lesson, organID: organID)
                LessonFooterActions(
                    isCompleted: appState.isLessonComplete(lesson.id),
                    toggleCompletion: {
                        appState.toggleLessonCompletion(lesson.id)
                    }
                )
            }
            .adaptiveContentWidth(900)
            .padding(20)
            .padding(.bottom, 24)
        }
        .navigationTitle(lesson.title)
        .navigationBarTitleDisplayMode(.inline)
        .anatomyScreenBackground()
    }
}

private struct StudySessionCard: View {
    @Environment(StudyActivityService.self) private var activityService
    let lesson: AnatomyLesson
    let organID: String

    private var organName: String {
        SampleAnatomyData.organs.first { $0.id == organID }?.title ?? "Anatomy"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Live Study Session", systemImage: "timer")
                .font(.headline)
                .foregroundStyle(AnatomyTheme.organColor(for: organID))

            Text("Show this lesson timer on the Lock Screen and Dynamic Island.")
                .font(.subheadline)
                .foregroundStyle(AnatomyTheme.textSecondary)

            if activityService.isActive {
                Text("Active: \(activityService.activeLessonTitle ?? "Study session")")
                    .font(.subheadline.weight(.semibold))

                Button("End Live Activity", role: .destructive) {
                    Task {
                        await activityService.endCurrentActivity()
                    }
                }
                .buttonStyle(.bordered)
            } else {
                Button {
                    Task {
                        await activityService.start(lesson: lesson, organName: organName)
                    }
                } label: {
                    Label(
                        "Start \(lesson.durationMinutes)-minute session",
                        systemImage: "play.circle.fill"
                    )
                    .font(.headline)
                    .frame(maxWidth: .infinity, minHeight: 48)
                }
                .buttonStyle(.borderedProminent)
                .tint(AnatomyTheme.organColor(for: organID))
            }

            if let errorMessage = activityService.errorMessage {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundStyle(AnatomyTheme.heart)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .anatomyCard()
    }
}

private struct LessonHeader: View {
    let lesson: AnatomyLesson
    let organID: String

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("LESSON \(lesson.number)")
                    .font(.caption.weight(.bold))
                    .tracking(1.4)
                    .foregroundStyle(AnatomyTheme.organColor(for: organID))
                Text(lesson.title)
                    .font(.largeTitle.weight(.bold))
                Text(lesson.summary)
                    .foregroundStyle(AnatomyTheme.textSecondary)
                Label("\(lesson.durationMinutes) min", systemImage: "clock.fill")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(AnatomyTheme.textSecondary)
            }
            Spacer()
            OrganArtworkView(organID: organID, size: 112)
        }
    }
}

private struct MotionLessonCard: View {
    let organID: String
    @State private var isPlaying = false
    @State private var pulse = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28)
                .fill(AnatomyTheme.organGradient(for: organID))

            Circle()
                .stroke(AnatomyTheme.organColor(for: organID).opacity(0.42), lineWidth: 2)
                .frame(width: pulse ? 230 : 150)
                .opacity(pulse ? 0 : 0.8)

            OrganArtworkView(organID: organID, size: 205)
                .scaleEffect(isPlaying && organID == "heart" ? (pulse ? 1.04 : 0.98) : 1)

            VStack {
                HStack {
                    Label("MOTION LESSON", systemImage: "play.rectangle.fill")
                        .font(.caption.weight(.bold))
                    Spacer()
                    Text("00:48")
                        .font(.caption.monospacedDigit())
                }
                .foregroundStyle(.white.opacity(0.76))
                Spacer()
                Button {
                    isPlaying.toggle()
                    pulse = false
                    if isPlaying {
                        withAnimation(.easeOut(duration: 1.2).repeatForever(autoreverses: false)) {
                            pulse = true
                        }
                    }
                } label: {
                    Label(isPlaying ? "Pause animation" : "Play anatomy motion", systemImage: isPlaying ? "pause.fill" : "play.fill")
                        .font(.headline)
                        .foregroundStyle(AnatomyTheme.background)
                        .padding(.horizontal, 18)
                        .frame(height: 48)
                        .background(.white, in: Capsule())
                }
            }
            .padding(18)
        }
        .frame(height: 320)
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .overlay { RoundedRectangle(cornerRadius: 28).stroke(.white.opacity(0.12)) }
        .accessibilityElement(children: .contain)
    }
}

private struct LessonTakeaway: View {
    let text: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Remember this", systemImage: "lightbulb.max.fill")
                .font(.headline)
                .foregroundStyle(color)
            Text(text)
                .font(.title3.weight(.semibold))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .anatomyCard()
    }
}

private struct LessonConcepts: View {
    let organID: String

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionTitle("How it works", eyebrow: "CORE CONCEPT")
            Label("Structures work together as one coordinated system.", systemImage: "1.circle.fill")
            Label("Direction and timing keep the process efficient.", systemImage: "2.circle.fill")
            Label("Tap related structures to build spatial understanding.", systemImage: "3.circle.fill")
        }
        .foregroundStyle(AnatomyTheme.textPrimary)
        .anatomyCard()
    }
}

private struct LessonFooterActions: View {
    let isCompleted: Bool
    let toggleCompletion: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            PrimaryButton(
                isCompleted ? "Mark as incomplete" : "Mark lesson complete",
                systemImage: isCompleted ? "arrow.uturn.backward.circle" : "checkmark.circle.fill",
                action: toggleCompletion
            )
            NavigationLink {
                ARPlaceholderView()
            } label: {
                Label("Preview in AR Lab", systemImage: "arkit")
                    .font(.headline)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .foregroundStyle(AnatomyTheme.teal)
                    .overlay { RoundedRectangle(cornerRadius: 16).stroke(AnatomyTheme.teal.opacity(0.6)) }
            }
        }
    }
}
