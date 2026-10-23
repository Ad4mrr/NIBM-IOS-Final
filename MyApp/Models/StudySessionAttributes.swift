import ActivityKit
import Foundation

// shared data shape used by both the app and the Live Activity widget
struct StudySessionAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        let endTime: Date
        let isComplete: Bool
    }

    let lessonTitle: String
    let organName: String
    let durationMinutes: Int
}
