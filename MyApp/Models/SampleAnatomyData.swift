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
        Organ(id: "heart", title: "Heart", systemName: "Circulatory System", description: "Learn how the heart pumps blood around the body.", symbolName: "heart.fill", lessons: heartLessons),
        Organ(id: "brain", title: "Brain", systemName: "Nervous System", description: "Explore the control centre of the nervous system.", symbolName: "brain.head.profile", lessons: [
            AnatomyLesson(id: "brain-overview", number: 1, title: "Overview", summary: "Introduction to the brain.", keyTakeaway: "The brain coordinates the body's activity.", durationMinutes: 6, structureCount: 4, status: .completed),
            AnatomyLesson(id: "brain-cerebrum", number: 2, title: "Cerebrum", summary: "Explore the largest brain region.", keyTakeaway: "The cerebrum supports thought and voluntary movement.", durationMinutes: 8, structureCount: 4, status: .inProgress),
            AnatomyLesson(id: "brain-cerebellum", number: 3, title: "Cerebellum", summary: "Learn about balance and coordination.", keyTakeaway: "The cerebellum fine-tunes movement.", durationMinutes: 7, structureCount: 3, status: .notStarted),
            AnatomyLesson(id: "brain-stem", number: 4, title: "Brain Stem", summary: "Study automatic body functions.", keyTakeaway: "The brain stem controls vital automatic functions.", durationMinutes: 7, structureCount: 3, status: .notStarted)
        ]),
        Organ(id: "lungs", title: "Lungs", systemName: "Respiratory System", description: "Discover how oxygen enters the blood.", symbolName: "lungs.fill", lessons: [
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

    static let quizQuestionsByOrganID: [String: [QuizQuestion]] = [
        "heart": [
            QuizQuestion(id: "heart-question-1", organTitle: "Heart", prompt: "How many chambers does the human heart have?", options: ["Two", "Three", "Four", "Five"], correctAnswerIndex: 2, explanation: "The heart has two atria and two ventricles, making four chambers in total.", memoryTip: "Two chambers receive and two chambers pump."),
            QuizQuestion(id: "heart-question-2", organTitle: "Heart", prompt: "Which chamber receives oxygen-poor blood from the body?", options: ["Right Atrium", "Left Atrium", "Right Ventricle", "Left Ventricle"], correctAnswerIndex: 0, explanation: "The superior and inferior venae cavae return oxygen-poor blood to the right atrium.", memoryTip: "Right atrium receives returning blood."),
            QuizQuestion(id: "heart-question-3", organTitle: "Heart", prompt: "Which chamber pumps oxygenated blood into the aorta?", options: ["Right Atrium", "Left Atrium", "Right Ventricle", "Left Ventricle"], correctAnswerIndex: 3, explanation: "The left ventricle contracts to push oxygen-rich blood through the aortic valve and into the aorta.", memoryTip: "Left leaves: blood leaves the heart from the left ventricle."),
            QuizQuestion(id: "heart-question-4", organTitle: "Heart", prompt: "What is the main purpose of the heart valves?", options: ["Create blood cells", "Prevent backward flow", "Add oxygen to blood", "Control body temperature"], correctAnswerIndex: 1, explanation: "Heart valves open and close to keep blood moving in one direction.", memoryTip: "Valves are one-way doors."),
            QuizQuestion(id: "heart-question-5", organTitle: "Heart", prompt: "Which vessel carries blood from the heart to the lungs?", options: ["Aorta", "Pulmonary artery", "Pulmonary vein", "Vena cava"], correctAnswerIndex: 1, explanation: "The pulmonary artery carries oxygen-poor blood from the right ventricle to the lungs.", memoryTip: "Pulmonary means lungs; the artery travels away from the heart.")
        ],
        "brain": [
            QuizQuestion(id: "brain-question-1", organTitle: "Brain", prompt: "Which is the largest part of the brain?", options: ["Cerebrum", "Cerebellum", "Brain stem", "Pituitary gland"], correctAnswerIndex: 0, explanation: "The cerebrum is the brain's largest region and supports thought, sensation, and voluntary movement.", memoryTip: "Cerebrum means the major thinking region."),
            QuizQuestion(id: "brain-question-2", organTitle: "Brain", prompt: "Which region primarily coordinates balance and precise movement?", options: ["Frontal lobe", "Cerebellum", "Medulla", "Hypothalamus"], correctAnswerIndex: 1, explanation: "The cerebellum coordinates balance, posture, and smooth movement.", memoryTip: "Cerebellum keeps movement controlled."),
            QuizQuestion(id: "brain-question-3", organTitle: "Brain", prompt: "Which brain region controls vital automatic functions such as breathing?", options: ["Parietal lobe", "Corpus callosum", "Brain stem", "Hippocampus"], correctAnswerIndex: 2, explanation: "The brain stem regulates breathing, heart rate, and other automatic functions.", memoryTip: "The brain stem keeps basic life functions running."),
            QuizQuestion(id: "brain-question-4", organTitle: "Brain", prompt: "Which lobe is strongly associated with vision?", options: ["Frontal", "Temporal", "Parietal", "Occipital"], correctAnswerIndex: 3, explanation: "The occipital lobe at the back of the brain processes visual information.", memoryTip: "Occipital is the optical-processing lobe."),
            QuizQuestion(id: "brain-question-5", organTitle: "Brain", prompt: "What is the basic signalling cell of the nervous system?", options: ["Neuron", "Platelet", "Osteocyte", "Alveolus"], correctAnswerIndex: 0, explanation: "Neurons receive, process, and transmit information using electrical and chemical signals.", memoryTip: "Neurons are the nervous system's messengers.")
        ],
        "lungs": [
            QuizQuestion(id: "lungs-question-1", organTitle: "Lungs", prompt: "What is the primary function of the lungs?", options: ["Digest food", "Exchange gases", "Filter urine", "Pump blood"], correctAnswerIndex: 1, explanation: "The lungs bring oxygen into the body and remove carbon dioxide.", memoryTip: "Lungs swap oxygen in and carbon dioxide out."),
            QuizQuestion(id: "lungs-question-2", organTitle: "Lungs", prompt: "Where does gas exchange occur?", options: ["Trachea", "Bronchi", "Alveoli", "Diaphragm"], correctAnswerIndex: 2, explanation: "Gas exchange occurs across the thin walls of the alveoli and surrounding capillaries.", memoryTip: "Alveoli are tiny air-exchange sacs."),
            QuizQuestion(id: "lungs-question-3", organTitle: "Lungs", prompt: "Which tube carries air from the throat toward the lungs?", options: ["Aorta", "Oesophagus", "Ureter", "Trachea"], correctAnswerIndex: 3, explanation: "The trachea carries air and divides into the right and left main bronchi.", memoryTip: "The trachea is the windpipe."),
            QuizQuestion(id: "lungs-question-4", organTitle: "Lungs", prompt: "What happens to the diaphragm during inhalation?", options: ["It contracts and moves down", "It relaxes and moves up", "It closes the trachea", "It stops blood flow"], correctAnswerIndex: 0, explanation: "The diaphragm contracts and flattens, increasing chest volume and drawing air inward.", memoryTip: "Diaphragm down draws air in."),
            QuizQuestion(id: "lungs-question-5", organTitle: "Lungs", prompt: "Which gas moves from the blood into the alveoli to be exhaled?", options: ["Oxygen", "Carbon dioxide", "Nitrogen", "Hydrogen"], correctAnswerIndex: 1, explanation: "Carbon dioxide diffuses from capillary blood into the alveoli and leaves during exhalation.", memoryTip: "Carbon dioxide is the waste gas breathed out.")
        ]
    ]

    static let favourites = [
        SavedStructure(id: "aorta", title: "Aorta", organTitle: "Heart", topic: "Major Vessels"),
        SavedStructure(id: "cerebellum", title: "Cerebellum", organTitle: "Brain", topic: "Hindbrain"),
        SavedStructure(id: "bronchi", title: "Bronchi", organTitle: "Lungs", topic: "Airways")
    ]

    static var heart: Organ {
        organs[0]
    }
}
