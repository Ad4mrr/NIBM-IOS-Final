import Foundation

enum SampleAnatomyData {
    static let heartLessons = [
        AnatomyLesson(id: "heart-overview", number: 1, title: "Overview", summary: "Meet the muscular pump at the centre of circulation.", keyTakeaway: "The heart moves blood through the lungs and the body.", durationMinutes: 6, structureCount: 4, status: .completed),
        AnatomyLesson(id: "heart-chambers", number: 2, title: "Chambers", summary: "Explore the four chambers of the heart.", keyTakeaway: "Atria receive blood while ventricles pump blood out.", durationMinutes: 8, structureCount: 4, status: .completed),
        AnatomyLesson(id: "heart-valves", number: 3, title: "Valves", summary: "See how valves guide blood in one direction.", keyTakeaway: "Valves prevent backward blood flow.", durationMinutes: 8, structureCount: 4, status: .inProgress),
        AnatomyLesson(id: "heart-vessels", number: 4, title: "Major Vessels", summary: "Identify the large vessels connected to the heart.", keyTakeaway: "Major vessels carry blood to and from the heart.", durationMinutes: 7, structureCount: 5, status: .notStarted),
        AnatomyLesson(id: "heart-flow", number: 5, title: "Blood Flow", summary: "Follow a complete journey through the heart.", keyTakeaway: "Blood follows a repeating route through both sides of the heart.", durationMinutes: 9, structureCount: 6, status: .notStarted)
    ]

    static let organs = [
        Organ(id: "heart", title: "Heart", systemName: "Circulatory System", description: "Learn how the heart pumps blood around the body.", symbolName: "heart.fill", progress: 0.60, bestQuizScore: 80, lessons: heartLessons),
        Organ(id: "brain", title: "Brain", systemName: "Nervous System", description: "Explore the control centre of the nervous system.", symbolName: "brain.head.profile", progress: 0.40, bestQuizScore: 60, lessons: [
            AnatomyLesson(id: "brain-overview", number: 1, title: "Overview", summary: "Introduction to the brain.", keyTakeaway: "The brain coordinates the body's activity.", durationMinutes: 6, structureCount: 4, status: .completed),
            AnatomyLesson(id: "brain-cerebrum", number: 2, title: "Cerebrum", summary: "Explore the largest brain region.", keyTakeaway: "The cerebrum supports thought and voluntary movement.", durationMinutes: 8, structureCount: 4, status: .inProgress),
            AnatomyLesson(id: "brain-cerebellum", number: 3, title: "Cerebellum", summary: "Learn about balance and coordination.", keyTakeaway: "The cerebellum fine-tunes movement.", durationMinutes: 7, structureCount: 3, status: .notStarted),
            AnatomyLesson(id: "brain-stem", number: 4, title: "Brain Stem", summary: "Study automatic body functions.", keyTakeaway: "The brain stem controls vital automatic functions.", durationMinutes: 7, structureCount: 3, status: .notStarted)
        ]),
        Organ(id: "lungs", title: "Lungs", systemName: "Respiratory System", description: "Discover how oxygen enters the blood.", symbolName: "lungs.fill", progress: 0.20, bestQuizScore: 40, lessons: [
            AnatomyLesson(id: "lungs-overview", number: 1, title: "Overview", summary: "Introduction to breathing.", keyTakeaway: "The lungs exchange oxygen and carbon dioxide.", durationMinutes: 6, structureCount: 4, status: .completed),
            AnatomyLesson(id: "lungs-airways", number: 2, title: "Airways", summary: "Follow air into the lungs.", keyTakeaway: "Airways branch to carry air through the lungs.", durationMinutes: 7, structureCount: 4, status: .notStarted),
            AnatomyLesson(id: "lungs-alveoli", number: 3, title: "Alveoli", summary: "Explore microscopic air sacs.", keyTakeaway: "Gas exchange occurs across thin alveolar walls.", durationMinutes: 8, structureCount: 3, status: .notStarted),
            AnatomyLesson(id: "lungs-breathing", number: 4, title: "Breathing", summary: "Learn how ventilation works.", keyTakeaway: "Pressure changes move air into and out of the lungs.", durationMinutes: 7, structureCount: 3, status: .notStarted)
        ])
    ]

    static let aorticValve = AnatomyStructure(
        id: "aortic-valve",
        title: "Aortic Valve",
        organTitle: "Heart",
        topic: "Valves",
        pathway: "Left Ventricle → Aorta",
        functionDescription: "Opens during ventricular contraction and prevents blood flowing backward into the left ventricle.",
        tags: ["Left Ventricle", "Aorta"]
    )

    static let quizQuestion = QuizQuestion(
        id: "heart-question-3",
        organTitle: "Heart",
        prompt: "Which chamber pumps oxygenated blood into the aorta?",
        options: ["Right Atrium", "Left Atrium", "Right Ventricle", "Left Ventricle"],
        correctAnswerIndex: 3,
        explanation: "The left ventricle contracts to push oxygen-rich blood through the aortic valve and into the aorta.",
        memoryTip: "Left leaves: blood leaves the heart from the left ventricle."
    )

    static let favourites = [
        SavedStructure(id: "aorta", title: "Aorta", organTitle: "Heart", topic: "Major Vessels"),
        SavedStructure(id: "cerebellum", title: "Cerebellum", organTitle: "Brain", topic: "Hindbrain"),
        SavedStructure(id: "bronchi", title: "Bronchi", organTitle: "Lungs", topic: "Airways")
    ]

    static var heart: Organ {
        organs[0]
    }
}
