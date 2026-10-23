import CoreData

// local data objects progress available offline
@objc(PersistedLearnerProfile)
final class PersistedLearnerProfile: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var learnerName: String
    @NSManaged var studyLevel: String
    @NSManaged var dailyGoalMinutes: Int16
}

@objc(PersistedLessonProgress)
final class PersistedLessonProgress: NSManagedObject {
    @NSManaged var lessonID: String
    @NSManaged var isCompleted: Bool
}

@objc(PersistedFavouriteStructure)
final class PersistedFavouriteStructure: NSManagedObject {
    @NSManaged var structureID: String
}

@objc(PersistedQuizScore)
final class PersistedQuizScore: NSManagedObject {
    @NSManaged var organID: String
    @NSManaged var bestScore: Int16
}
