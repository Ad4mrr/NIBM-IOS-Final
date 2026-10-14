import Foundation

struct Organ: Identifiable, Hashable {
    let id: String
    let title: String
    let systemName: String
    let description: String
    let symbolName: String
    let progress: Double
    let bestQuizScore: Int
    let lessons: [AnatomyLesson]

    var completedLessonCount: Int {
        lessons.filter(\.isCompleted).count
    }
}

struct AnatomyLesson: Identifiable, Hashable {
    let id: String
    let number: Int
    let title: String
    let summary: String
    let keyTakeaway: String
    let durationMinutes: Int
    let structureCount: Int
    let status: LessonStatus

    var isCompleted: Bool {
        status == .completed
    }
}

enum LessonStatus: String, Hashable {
    case completed = "Completed"
    case inProgress = "In Progress"
    case notStarted = "Not Started"

    var symbolName: String {
        switch self {
        case .completed:
            "checkmark.circle.fill"
        case .inProgress:
            "circle.lefthalf.filled"
        case .notStarted:
            "circle"
        }
    }
}

struct AnatomyStructure: Identifiable, Hashable {
    let id: String
    let title: String
    let organTitle: String
    let topic: String
    let pathway: String
    let functionDescription: String
    let tags: [String]
}

struct QuizQuestion: Identifiable, Hashable {
    let id: String
    let organTitle: String
    let prompt: String
    let options: [String]
    let correctAnswerIndex: Int
    let explanation: String
    let memoryTip: String
}

struct SavedStructure: Identifiable, Hashable {
    let id: String
    let title: String
    let organTitle: String
    let topic: String
}
