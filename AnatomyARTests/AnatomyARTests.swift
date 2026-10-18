import Testing
@testable import MyApp

@Suite("Learner progress", .serialized)
@MainActor
struct LearnerProgressTests {
    private func makeAppState() -> AppState {
        AppState(persistenceController: PersistenceController(inMemory: true))
    }

    @Test("A new learner starts with no completed lessons")
    func newLearnerProgress() {
        let appState = makeAppState()

        #expect(appState.completedLessonCount(for: SampleAnatomyData.heart) == 0)
        #expect(appState.progress(for: SampleAnatomyData.heart) == 0)
    }

    @Test("Completing a lesson updates its organ progress")
    func lessonCompletionUpdatesProgress() {
        let appState = makeAppState()
        let heart = SampleAnatomyData.heart
        let lessonID = heart.lessons[0].id

        appState.toggleLessonCompletion(lessonID)

        #expect(appState.isLessonComplete(lessonID))
        #expect(appState.completedLessonCount(for: heart) == 1)
        #expect(appState.progress(for: heart) == 1.0 / Double(heart.lessons.count))
    }

    @Test("Toggling a completed lesson removes its progress")
    func lessonCompletionCanBeRemoved() {
        let appState = makeAppState()
        let lessonID = SampleAnatomyData.heart.lessons[0].id

        appState.toggleLessonCompletion(lessonID)
        appState.toggleLessonCompletion(lessonID)

        #expect(!appState.isLessonComplete(lessonID))
        #expect(appState.progress(for: SampleAnatomyData.heart) == 0)
    }

    @Test("Quiz progress keeps only the best score")
    func quizKeepsBestScore() {
        let appState = makeAppState()

        appState.recordQuizResult(organID: "heart", correctAnswers: 4, totalQuestions: 5)
        appState.recordQuizResult(organID: "heart", correctAnswers: 2, totalQuestions: 5)

        #expect(appState.bestQuizScore(for: "heart") == 80)
    }

    @Test("Invalid quiz totals do not create a score")
    func invalidQuizTotalIsIgnored() {
        let appState = makeAppState()

        appState.recordQuizResult(organID: "brain", correctAnswers: 1, totalQuestions: 0)

        #expect(appState.bestQuizScore(for: "brain") == 0)
    }

    @Test("A saved structure can be added and removed")
    func favouriteCanBeToggled() {
        let appState = makeAppState()
        let structureID = "test-structure"

        appState.toggleFavourite(structureID)
        #expect(appState.isFavourite(structureID))

        appState.toggleFavourite(structureID)
        #expect(!appState.isFavourite(structureID))
    }
}

@Suite("Anatomy models")
struct AnatomyModelTests {
    @Test("Completed lesson count matches lesson statuses")
    func completedLessonCount() {
        #expect(SampleAnatomyData.heart.completedLessonCount == 2)
    }

    @Test(
        "Lesson statuses use the expected symbols",
        arguments: [
            (LessonStatus.completed, "checkmark.circle.fill"),
            (LessonStatus.inProgress, "circle.lefthalf.filled"),
            (LessonStatus.notStarted, "circle")
        ]
    )
    func lessonStatusSymbol(status: LessonStatus, expectedSymbol: String) {
        #expect(status.symbolName == expectedSymbol)
    }

    @Test("The sample quiz answer points to the left ventricle")
    func quizAnswerIsValid() {
        let question = SampleAnatomyData.quizQuestion

        #expect(question.correctAnswerIndex < question.options.count)
        #expect(question.options[question.correctAnswerIndex] == "Left Ventricle")
    }
}
