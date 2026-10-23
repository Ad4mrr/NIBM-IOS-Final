import Foundation
import WidgetKit

enum WidgetProgressService {
    static let widgetKind = "AnatomyARProgress"
    static let appGroupID = "group.com.ravinduwijethunga.AnatomyAR"

    static func update(
        organs: [Organ],
        completedLessonIDs: Set<String>,
        bestQuizScores: [String: Int]
    ) {
        guard let defaults = UserDefaults(suiteName: appGroupID) else { return }
        let totalLessons = organs.reduce(0) { $0 + $1.lessons.count }
        let completedLessons = organs.reduce(0) { result, organ in
            result + organ.lessons.filter { completedLessonIDs.contains($0.id) }.count
        }

        defaults.set(completedLessons, forKey: "widget.completedLessons")
        defaults.set(totalLessons, forKey: "widget.totalLessons")

        for organ in organs {
            let completed = organ.lessons.filter { completedLessonIDs.contains($0.id) }.count
            let progress = organ.lessons.isEmpty
                ? 0
                : Double(completed) / Double(organ.lessons.count)

            defaults.set(progress, forKey: "widget.\(organ.id).progress")
            defaults.set(bestQuizScores[organ.id, default: 0], forKey: "widget.\(organ.id).quiz")
        }

        WidgetCenter.shared.reloadTimelines(ofKind: widgetKind)
    }
}
