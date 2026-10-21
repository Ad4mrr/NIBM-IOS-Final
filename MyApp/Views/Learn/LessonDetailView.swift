import AVKit
import SwiftUI

struct LessonDetailView: View {
    @Environment(AppState.self) private var appState
    let lesson: AnatomyLesson

    private var organID: String {
        lesson.id.components(separatedBy: "-").first ?? "heart"
    }

    private var content: LessonContent {
        SampleAnatomyData.lessonContentByID[lesson.id] ?? LessonContent(
            overview: lesson.summary,
            concepts: [lesson.keyTakeaway],
            structures: []
        )
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 24) {
                LessonHeader(lesson: lesson, organID: organID)
                LessonVideoCard(organID: organID, lessonTitle: lesson.title)
                LessonExplanation(text: content.overview)
                LessonTakeaway(text: lesson.keyTakeaway, color: AnatomyTheme.organColor(for: organID))
                LessonConcepts(concepts: content.concepts, organID: organID)
                LessonStructures(structures: content.structures, organID: organID)
                StudySessionCard(lesson: lesson, organID: organID)
                LessonFooterActions(
                    organID: organID,
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

private struct LessonVideoCard: View {
    let organID: String
    let lessonTitle: String
    @State private var player: AVPlayer?

    private var videoTitle: String {
        "\(lessonTitle) video lesson"
    }

    private var videoName: String {
        switch organID {
        case "brain": "BrainVideo"
        case "lungs": "LungsVideo"
        default: "HeartVideo"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label("VIDEO LESSON", systemImage: "play.rectangle.fill")
                .font(.caption.weight(.bold))
                .foregroundStyle(AnatomyTheme.organColor(for: organID))

            Text(videoTitle)
                .font(.title3.weight(.bold))

            if let player {
                VideoPlayer(player: player)
                    // The edited lesson videos use a standard horizontal format.
                    .aspectRatio(16 / 9, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .overlay {
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(.white.opacity(0.12))
                    }
                    .accessibilityLabel("\(videoTitle) video")
            } else {
                ContentUnavailableView(
                    "Video unavailable",
                    systemImage: "video.slash",
                    description: Text("The lesson video could not be loaded.")
                )
                .frame(maxWidth: .infinity, minHeight: 220)
            }

            Text("Use the player controls to play, pause, scrub, or watch full screen.")
                .font(.footnote)
                .foregroundStyle(AnatomyTheme.textSecondary)
        }
        .anatomyCard()
        .onAppear {
            loadVideo()
        }
        .onDisappear {
            // Stop audio when the learner leaves the lesson screen.
            player?.pause()
        }
    }

    private func loadVideo() {
        guard player == nil,
              let videoURL = Bundle.main.url(forResource: videoName, withExtension: "mp4") else {
            return
        }

        // AVPlayer supplies the standard iOS playback and full-screen controls.
        player = AVPlayer(url: videoURL)
    }
}

private struct LessonExplanation: View {
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionTitle("Study notes", eyebrow: "LESSON CONTENT")
            Text(text)
                .font(.body)
                .foregroundStyle(AnatomyTheme.textSecondary)
                .lineSpacing(5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .anatomyCard()
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
    let concepts: [String]
    let organID: String

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionTitle("How it works", eyebrow: "KEY CONCEPTS")
            ForEach(Array(concepts.enumerated()), id: \.element) { index, concept in
                Label(concept, systemImage: "\(index + 1).circle.fill")
                    .foregroundStyle(AnatomyTheme.textPrimary)
            }
        }
        .anatomyCard()
    }
}

private struct LessonStructures: View {
    let structures: [LessonStructure]
    let organID: String

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionTitle("Structures to know", eyebrow: "ANATOMY")

            ForEach(structures, id: \.name) { structure in
                VStack(alignment: .leading, spacing: 4) {
                    Label(structure.name, systemImage: "scope")
                        .font(.headline)
                        .foregroundStyle(AnatomyTheme.organColor(for: organID))
                    Text(structure.function)
                        .font(.subheadline)
                        .foregroundStyle(AnatomyTheme.textSecondary)
                        .padding(.leading, 28)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .anatomyCard()
    }
}

private struct LessonFooterActions: View {
    let organID: String
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
                ARPlaceholderView(initialOrganID: organID)
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
