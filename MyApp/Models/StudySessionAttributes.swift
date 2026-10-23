import ActivityKit
import Foundation

// shared app and widget data
struct StudySessionAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        let endTime: Date
        let isComplete: Bool
    }

    let lessonTitle: String
    let organName: String
    let durationMinutes: Int
}
