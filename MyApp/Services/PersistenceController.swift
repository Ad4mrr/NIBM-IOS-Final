import CoreData
import Foundation

@MainActor
final class PersistenceController {
    // shared local data container
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    var context: NSManagedObjectContext {
        container.viewContext
    }

    init(inMemory: Bool = false) {
        // memory store for tests
        container = NSPersistentContainer(
            name: "AnatomyAR",
            managedObjectModel: Self.makeManagedObjectModel()
        )

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true

        container.loadPersistentStores { _, error in
            if let error {
                // non-fatal save errors
                print("Core Data store failed to load: \(error.localizedDescription)")
            }
        }
    }

    func save() throws {
        // empty save check
        guard context.hasChanges else { return }
        try context.save()
    }

    private static func makeManagedObjectModel() -> NSManagedObjectModel {
        // four local data entities
        // code-built local data model
        let model = NSManagedObjectModel()
        model.entities = [
            makeLearnerProfileEntity(),
            makeLessonProgressEntity(),
            makeFavouriteStructureEntity(),
            makeQuizScoreEntity()
        ]
        return model
    }

    private static func makeLearnerProfileEntity() -> NSEntityDescription {
        let entity = NSEntityDescription()
        entity.name = "PersistedLearnerProfile"
        entity.managedObjectClassName = NSStringFromClass(PersistedLearnerProfile.self)
        entity.properties = [
            attribute(name: "id", type: .stringAttributeType),
            attribute(name: "learnerName", type: .stringAttributeType),
            attribute(name: "studyLevel", type: .stringAttributeType),
            attribute(name: "dailyGoalMinutes", type: .integer16AttributeType)
        ]
        entity.uniquenessConstraints = [["id"]]
        return entity
    }

    private static func makeLessonProgressEntity() -> NSEntityDescription {
        let entity = NSEntityDescription()
        entity.name = "PersistedLessonProgress"
        entity.managedObjectClassName = NSStringFromClass(PersistedLessonProgress.self)
        entity.properties = [
            attribute(name: "lessonID", type: .stringAttributeType),
            attribute(name: "isCompleted", type: .booleanAttributeType)
        ]
        entity.uniquenessConstraints = [["lessonID"]]
        return entity
    }

    private static func makeFavouriteStructureEntity() -> NSEntityDescription {
        let entity = NSEntityDescription()
        entity.name = "PersistedFavouriteStructure"
        entity.managedObjectClassName = NSStringFromClass(PersistedFavouriteStructure.self)
        entity.properties = [
            attribute(name: "structureID", type: .stringAttributeType)
        ]
        entity.uniquenessConstraints = [["structureID"]]
        return entity
    }

    private static func makeQuizScoreEntity() -> NSEntityDescription {
        let entity = NSEntityDescription()
        entity.name = "PersistedQuizScore"
        entity.managedObjectClassName = NSStringFromClass(PersistedQuizScore.self)
        entity.properties = [
            attribute(name: "organID", type: .stringAttributeType),
            attribute(name: "bestScore", type: .integer16AttributeType)
        ]
        entity.uniquenessConstraints = [["organID"]]
        return entity
    }

    private static func attribute(
        name: String,
        type: NSAttributeType
    ) -> NSAttributeDescription {
        let attribute = NSAttributeDescription()
        attribute.name = name
        attribute.attributeType = type
        attribute.isOptional = false
        return attribute
    }
}
