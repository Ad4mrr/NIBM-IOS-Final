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

    @Test("Quiz progress advances and keeps only the best score")
    func quizProgressKeepsBestScore() {
        let appState = makeAppState()

        #expect(appState.bestQuizScore(for: "heart") == 0)

        appState.recordQuizResult(organID: "heart", correctAnswers: 3, totalQuestions: 5)
        #expect(appState.bestQuizScore(for: "heart") == 60)

        appState.recordQuizResult(organID: "heart", correctAnswers: 4, totalQuestions: 5)
        #expect(appState.bestQuizScore(for: "heart") == 80)

        appState.recordQuizResult(organID: "heart", correctAnswers: 2, totalQuestions: 5)
        #expect(appState.bestQuizScore(for: "heart") == 80)
    }

    @Test("Resetting study progress clears lessons and quiz scores")
    func resetStudyProgress() {
        let appState = makeAppState()
        let lessonID = SampleAnatomyData.heart.lessons[0].id
        let savedStructureID = SampleAnatomyData.aorta.id

        appState.toggleFavourite(savedStructureID)
        appState.toggleLessonCompletion(lessonID)
        appState.recordQuizResult(organID: "heart", correctAnswers: 4, totalQuestions: 5)

        #expect(appState.isLessonComplete(lessonID))
        #expect(appState.bestQuizScore(for: "heart") == 80)
        #expect(appState.isFavourite(savedStructureID))

        appState.resetStudyProgress()

        #expect(!appState.isLessonComplete(lessonID))
        #expect(appState.bestQuizScore(for: "heart") == 0)
        #expect(appState.isFavourite(savedStructureID))
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

    @Test("Every quiz question has a valid answer")
    func quizAnswersAreValid() {
        let questions = SampleAnatomyData.quizQuestionsByOrganID.values.flatMap { $0 }

        #expect(!questions.isEmpty)

        for question in questions {
            #expect(!question.options.isEmpty)
            #expect(question.options.indices.contains(question.correctAnswerIndex))
        }
    }

    @Test("Every lesson structure has a saved-structure detail record")
    func lessonStructuresHaveDetailRecords() throws {
        for organ in SampleAnatomyData.organs {
            for lesson in organ.lessons {
                let content = try #require(
                    SampleAnatomyData.lessonContentByID[lesson.id],
                    "Missing lesson content for \(lesson.id)"
                )

                for lessonStructure in content.structures {
                    let structure = SampleAnatomyData.structure(
                        for: lessonStructure,
                        lesson: lesson,
                        organID: organ.id
                    )

                    #expect(SampleAnatomyData.structures.contains(where: { $0.id == structure.id }))
                    #expect(!structure.functionDescription.isEmpty)
                }
            }
        }
    }
}
