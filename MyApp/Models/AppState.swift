import Foundation
import Observation

enum AppRoute: Equatable {
    case authentication
    case main
}

@MainActor
@Observable
final class AppState {
    var route: AppRoute = .authentication
    var learnerName = "Ravindu"
    var studyLevel = "Foundation"
    var dailyGoalMinutes = 10

    private(set) var completedLessonIDs: Set<String>
    private(set) var favouriteStructureIDs: Set<String>
    private(set) var bestQuizScores: [String: Int]

    init() {
        completedLessonIDs = Set(
            SampleAnatomyData.organs
                .flatMap(\.lessons)
                .filter(\.isCompleted)
                .map(\.id)
        )
        favouriteStructureIDs = Set(SampleAnatomyData.favourites.map(\.id))
        bestQuizScores = Dictionary(
            uniqueKeysWithValues: SampleAnatomyData.organs.map { ($0.id, $0.bestQuizScore) }
        )
    }

    func finishOnboarding() {
        route = .main
    }

    func signOut() {
        route = .authentication
    }

    func isLessonComplete(_ lessonID: String) -> Bool {
        completedLessonIDs.contains(lessonID)
    }

    func toggleLessonCompletion(_ lessonID: String) {
        if completedLessonIDs.contains(lessonID) {
            completedLessonIDs.remove(lessonID)
        } else {
            completedLessonIDs.insert(lessonID)
        }
    }

    func completedLessonCount(for organ: Organ) -> Int {
        organ.lessons.reduce(into: 0) { count, lesson in
            if completedLessonIDs.contains(lesson.id) {
                count += 1
            }
        }
    }

    func progress(for organ: Organ) -> Double {
        guard !organ.lessons.isEmpty else { return 0 }
        return Double(completedLessonCount(for: organ)) / Double(organ.lessons.count)
    }

    func bestQuizScore(for organID: String) -> Int {
        bestQuizScores[organID, default: 0]
    }

    func recordQuizResult(organID: String, correctAnswers: Int, totalQuestions: Int) {
        guard totalQuestions > 0 else { return }
        let score = Int((Double(correctAnswers) / Double(totalQuestions) * 100).rounded())
        bestQuizScores[organID] = max(bestQuizScores[organID, default: 0], score)
    }

    func isFavourite(_ structureID: String) -> Bool {
        favouriteStructureIDs.contains(structureID)
    }

    func toggleFavourite(_ structureID: String) {
        if favouriteStructureIDs.contains(structureID) {
            favouriteStructureIDs.remove(structureID)
        } else {
            favouriteStructureIDs.insert(structureID)
        }
    }
}
