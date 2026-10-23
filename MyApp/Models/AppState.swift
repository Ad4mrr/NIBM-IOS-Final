import CoreData
import Foundation
import Observation

enum AppRoute: Equatable {
    case authentication
    case main
}

struct StudyProgressSnapshot: Equatable {
    let completedLessonIDs: Set<String>
    let favouriteStructureIDs: Set<String>
    let bestQuizScores: [String: Int]
}

@MainActor
@Observable
final class AppState {
    // profile and progress cache
    var route: AppRoute = .authentication

    var learnerName = "Ravindu" {
        didSet { saveProfileWhenReady() }
    }

    var studyLevel = "Foundation" {
        didSet { saveProfileWhenReady() }
    }

    var dailyGoalMinutes = 10 {
        didSet { saveProfileWhenReady() }
    }

    private(set) var completedLessonIDs: Set<String> = []
    private(set) var favouriteStructureIDs: Set<String> = []
    private(set) var bestQuizScores: [String: Int] = [:]
    private(set) var persistenceErrorMessage: String?

    @ObservationIgnored private let persistenceController: PersistenceController
    @ObservationIgnored private var isLoadingPersistedState = true

    init(persistenceController: PersistenceController? = nil) {
        // test store support
        self.persistenceController = persistenceController ?? PersistenceController.shared
        loadPersistedState()
    }

    func finishOnboarding() {
        route = .main
    }

    func applyRemoteProfile(_ profile: RemoteLearnerProfile) {
        // local profile save
        learnerName = profile.learnerName
        studyLevel = profile.studyLevel
        dailyGoalMinutes = profile.dailyGoalMinutes
    }

    func signOut() {
        route = .authentication
    }

    func isLessonComplete(_ lessonID: String) -> Bool {
        completedLessonIDs.contains(lessonID)
    }

    var studyProgressSnapshot: StudyProgressSnapshot {
        // firebase profile snapshot
        StudyProgressSnapshot(
            completedLessonIDs: completedLessonIDs,
            favouriteStructureIDs: favouriteStructureIDs,
            bestQuizScores: bestQuizScores
        )
    }

    func applyRemoteStudyProgress(_ progress: StudyProgressSnapshot) {
        // duplicate sync check
        guard progress != studyProgressSnapshot else { return }

        completedLessonIDs = progress.completedLessonIDs
        favouriteStructureIDs = progress.favouriteStructureIDs
        bestQuizScores = progress.bestQuizScores
        replacePersistedStudyProgress()
        updateWidgetProgress()
    }

    func toggleLessonCompletion(_ lessonID: String) {
        // ui save and widget sync
        let isNowCompleted: Bool

        if completedLessonIDs.contains(lessonID) {
            completedLessonIDs.remove(lessonID)
            isNowCompleted = false
        } else {
            completedLessonIDs.insert(lessonID)
            isNowCompleted = true
        }

        saveLessonProgress(lessonID: lessonID, isCompleted: isNowCompleted)
        updateWidgetProgress()
    }

    func completedLessonCount(for organ: Organ) -> Int {
        organ.lessons.reduce(into: 0) { count, lesson in
            if completedLessonIDs.contains(lesson.id) {
                count += 1
            }
        }
    }

    func progress(for organ: Organ) -> Double {
        // progress range 0 to 1
        guard !organ.lessons.isEmpty else { return 0 }
        return Double(completedLessonCount(for: organ)) / Double(organ.lessons.count)
    }

    func bestQuizScore(for organID: String) -> Int {
        bestQuizScores[organID, default: 0]
    }

    var quizAverage: Int {
        guard !bestQuizScores.isEmpty else { return 0 }
        return bestQuizScores.values.reduce(0, +) / bestQuizScores.count
    }

    func recordQuizResult(organID: String, correctAnswers: Int, totalQuestions: Int) {
        // best score only
        guard totalQuestions > 0 else { return }

        let score = Int((Double(correctAnswers) / Double(totalQuestions) * 100).rounded())
        let previousBest = bestQuizScores[organID, default: 0]
        guard score > previousBest else { return }

        bestQuizScores[organID] = score
        saveQuizScore(organID: organID, score: score)
        updateWidgetProgress()
    }

    func resetStudyProgress() {
        // saved item bookmarks
        let context = persistenceController.context

        do {
            let lessonRequest = NSFetchRequest<PersistedLessonProgress>(
                entityName: "PersistedLessonProgress"
            )
            for lessonProgress in try context.fetch(lessonRequest) {
                context.delete(lessonProgress)
            }

            let quizRequest = NSFetchRequest<PersistedQuizScore>(
                entityName: "PersistedQuizScore"
            )
            for quizScore in try context.fetch(quizRequest) {
                context.delete(quizScore)
            }

            try persistenceController.save()
            completedLessonIDs = []
            bestQuizScores = [:]
            persistenceErrorMessage = nil
            updateWidgetProgress()
        } catch {
            context.rollback()
            recordPersistenceError(error)
        }
    }

    func isFavourite(_ structureID: String) -> Bool {
        favouriteStructureIDs.contains(structureID)
    }

    func toggleFavourite(_ structureID: String) {
        // duplicate item check
        if favouriteStructureIDs.contains(structureID) {
            favouriteStructureIDs.remove(structureID)
            deleteFavourite(structureID: structureID)
        } else {
            favouriteStructureIDs.insert(structureID)
            saveFavourite(structureID: structureID)
        }
    }

    private func loadPersistedState() {
        // one-time local data load
        defer { updateWidgetProgress() }
        let context = persistenceController.context

        do {
            let profileRequest = NSFetchRequest<PersistedLearnerProfile>(
                entityName: "PersistedLearnerProfile"
            )
            profileRequest.fetchLimit = 1

            guard let profile = try context.fetch(profileRequest).first else {
                seedInitialState()
                isLoadingPersistedState = false
                saveInitialState()
                return
            }

            learnerName = profile.learnerName
            studyLevel = profile.studyLevel
            dailyGoalMinutes = Int(profile.dailyGoalMinutes)

            let lessonRequest = NSFetchRequest<PersistedLessonProgress>(
                entityName: "PersistedLessonProgress"
            )
            completedLessonIDs = Set(
                try context.fetch(lessonRequest)
                    .filter(\.isCompleted)
                    .map(\.lessonID)
            )

            let favouriteRequest = NSFetchRequest<PersistedFavouriteStructure>(
                entityName: "PersistedFavouriteStructure"
            )
            favouriteStructureIDs = Set(
                try context.fetch(favouriteRequest).map(\.structureID)
            )

            let quizRequest = NSFetchRequest<PersistedQuizScore>(
                entityName: "PersistedQuizScore"
            )
            bestQuizScores = Dictionary(
                uniqueKeysWithValues: try context.fetch(quizRequest).map {
                    ($0.organID, Int($0.bestScore))
                }
            )

            isLoadingPersistedState = false
        } catch {
            persistenceErrorMessage = error.localizedDescription
            seedInitialState()
            isLoadingPersistedState = false
        }
    }

    private func seedInitialState() {
        // empty progress for new users
        completedLessonIDs = []
        favouriteStructureIDs = []
        bestQuizScores = [:]
    }

    private func saveInitialState() {
        let context = persistenceController.context

        let profile = PersistedLearnerProfile(context: context)
        profile.id = "current-learner"
        profile.learnerName = learnerName
        profile.studyLevel = studyLevel
        profile.dailyGoalMinutes = Int16(dailyGoalMinutes)

        for lesson in SampleAnatomyData.organs.flatMap(\.lessons) {
            let progress = PersistedLessonProgress(context: context)
            progress.lessonID = lesson.id
            progress.isCompleted = completedLessonIDs.contains(lesson.id)
        }

        for structureID in favouriteStructureIDs {
            let favourite = PersistedFavouriteStructure(context: context)
            favourite.structureID = structureID
        }

        for (organID, score) in bestQuizScores {
            let quizScore = PersistedQuizScore(context: context)
            quizScore.organID = organID
            quizScore.bestScore = Int16(score)
        }

        saveContext()
    }

    private func saveProfileWhenReady() {
        // no saves during first load
        guard !isLoadingPersistedState else { return }

        let request = NSFetchRequest<PersistedLearnerProfile>(
            entityName: "PersistedLearnerProfile"
        )
        request.fetchLimit = 1

        do {
            let profile = try persistenceController.context.fetch(request).first
                ?? PersistedLearnerProfile(context: persistenceController.context)
            profile.id = "current-learner"
            profile.learnerName = learnerName
            profile.studyLevel = studyLevel
            profile.dailyGoalMinutes = Int16(dailyGoalMinutes)
            saveContext()
        } catch {
            recordPersistenceError(error)
        }
    }

    private func saveLessonProgress(lessonID: String, isCompleted: Bool) {
        // lesson progress upsert
        let request = NSFetchRequest<PersistedLessonProgress>(
            entityName: "PersistedLessonProgress"
        )
        request.predicate = NSPredicate(format: "lessonID == %@", lessonID)
        request.fetchLimit = 1

        do {
            let progress = try persistenceController.context.fetch(request).first
                ?? PersistedLessonProgress(context: persistenceController.context)
            progress.lessonID = lessonID
            progress.isCompleted = isCompleted
            saveContext()
        } catch {
            recordPersistenceError(error)
        }
    }

    private func saveFavourite(structureID: String) {
        let favourite = PersistedFavouriteStructure(context: persistenceController.context)
        favourite.structureID = structureID
        saveContext()
    }

    private func deleteFavourite(structureID: String) {
        let request = NSFetchRequest<PersistedFavouriteStructure>(
            entityName: "PersistedFavouriteStructure"
        )
        request.predicate = NSPredicate(format: "structureID == %@", structureID)

        do {
            for favourite in try persistenceController.context.fetch(request) {
                persistenceController.context.delete(favourite)
            }
            saveContext()
        } catch {
            recordPersistenceError(error)
        }
    }

    private func saveQuizScore(organID: String, score: Int) {
        // one best score per organ
        let request = NSFetchRequest<PersistedQuizScore>(
            entityName: "PersistedQuizScore"
        )
        request.predicate = NSPredicate(format: "organID == %@", organID)
        request.fetchLimit = 1

        do {
            let quizScore = try persistenceController.context.fetch(request).first
                ?? PersistedQuizScore(context: persistenceController.context)
            quizScore.organID = organID
            quizScore.bestScore = Int16(score)
            saveContext()
        } catch {
            recordPersistenceError(error)
        }
    }

    private func replacePersistedStudyProgress() {
        let context = persistenceController.context

        do {
            // firebase progress saved offline
            for item in try context.fetch(NSFetchRequest<PersistedLessonProgress>(
                entityName: "PersistedLessonProgress"
            )) {
                context.delete(item)
            }
            for lessonID in completedLessonIDs {
                let progress = PersistedLessonProgress(context: context)
                progress.lessonID = lessonID
                progress.isCompleted = true
            }

            for item in try context.fetch(NSFetchRequest<PersistedFavouriteStructure>(
                entityName: "PersistedFavouriteStructure"
            )) {
                context.delete(item)
            }
            for structureID in favouriteStructureIDs {
                let favourite = PersistedFavouriteStructure(context: context)
                favourite.structureID = structureID
            }

            for item in try context.fetch(NSFetchRequest<PersistedQuizScore>(
                entityName: "PersistedQuizScore"
            )) {
                context.delete(item)
            }
            for (organID, score) in bestQuizScores {
                let quizScore = PersistedQuizScore(context: context)
                quizScore.organID = organID
                quizScore.bestScore = Int16(score)
            }

            try persistenceController.save()
            persistenceErrorMessage = nil
        } catch {
            context.rollback()
            recordPersistenceError(error)
        }
    }

    private func saveContext() {
        // shared local data errors
        do {
            try persistenceController.save()
            persistenceErrorMessage = nil
        } catch {
            recordPersistenceError(error)
        }
    }

    private func recordPersistenceError(_ error: Error) {
        persistenceErrorMessage = error.localizedDescription
        print("Core Data save failed: \(error.localizedDescription)")
    }

    private func updateWidgetProgress() {
        // small widget data summary
        WidgetProgressService.update(
            organs: SampleAnatomyData.organs,
            completedLessonIDs: completedLessonIDs,
            bestQuizScores: bestQuizScores
        )
    }
}
