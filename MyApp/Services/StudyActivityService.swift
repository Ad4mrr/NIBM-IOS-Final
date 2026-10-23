import ActivityKit
import Foundation
import Observation

@MainActor
@Observable
final class StudyActivityService {
    // only one lesson Live Activity is kept active at a time
    private(set) var isActive = false
    private(set) var activeLessonTitle: String?
    private(set) var errorMessage: String?

    init() {
        refresh()
    }

    func refresh() {
        // restore the active state when the app returns to the foreground
        let activity = Activity<StudySessionAttributes>.activities.first
        isActive = activity != nil
        activeLessonTitle = activity?.attributes.lessonTitle
    }

    func start(lesson: AnatomyLesson, organName: String) async {
        // the end time drives the countdown displayed by the Live Activity
        errorMessage = nil

        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            errorMessage = "Live Activities are disabled in iOS Settings."
            return
        }

        await endCurrentActivity()

        let attributes = StudySessionAttributes(
            lessonTitle: lesson.title,
            organName: organName,
            durationMinutes: lesson.durationMinutes
        )
        let endTime = Date.now.addingTimeInterval(Double(lesson.durationMinutes * 60))
        let state = StudySessionAttributes.ContentState(
            endTime: endTime,
            isComplete: false
        )

        do {
            _ = try Activity.request(
                attributes: attributes,
                content: ActivityContent(state: state, staleDate: endTime),
                pushType: nil
            )
            refresh()
        } catch {
            errorMessage = "Could not start the Live Activity: \(error.localizedDescription)"
        }
    }

    func endCurrentActivity() async {
        // end every matching activity in case iOS restored more than one
        for activity in Activity<StudySessionAttributes>.activities {
            let finalState = StudySessionAttributes.ContentState(
                endTime: .now,
                isComplete: true
            )
            await activity.end(
                ActivityContent(state: finalState, staleDate: nil),
                dismissalPolicy: .immediate
            )
        }
        refresh()
    }
}
