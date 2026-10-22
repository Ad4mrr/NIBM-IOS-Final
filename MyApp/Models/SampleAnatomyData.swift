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

    static let lessonContentByID: [String: LessonContent] = [
        "heart-overview": LessonContent(
            overview: "The heart is a muscular organ in the chest between the lungs. Its rhythmic contractions create the pressure that moves blood through pulmonary circulation to the lungs and systemic circulation to the rest of the body.",
            concepts: ["The right side sends oxygen-poor blood to the lungs.", "The left side sends oxygen-rich blood to the body.", "The cardiac cycle alternates filling and pumping phases."],
            structures: [LessonStructure(name: "Atria", function: "Upper chambers that receive blood."), LessonStructure(name: "Ventricles", function: "Lower chambers that pump blood out."), LessonStructure(name: "Septum", function: "Wall separating the right and left sides."), LessonStructure(name: "Coronary vessels", function: "Supply the heart muscle itself.")]
        ),
        "heart-chambers": LessonContent(
            overview: "Four chambers divide the heart into two coordinated pumps. The atria receive returning blood and pass it to the ventricles, whose thicker walls generate the force needed to move blood onward.",
            concepts: ["The right atrium receives blood from the venae cavae.", "The right ventricle pumps blood toward the lungs.", "The left ventricle has the thickest wall because it pumps through the whole body."],
            structures: [LessonStructure(name: "Right atrium", function: "Receives oxygen-poor systemic blood."), LessonStructure(name: "Right ventricle", function: "Pumps blood into the pulmonary artery."), LessonStructure(name: "Left atrium", function: "Receives oxygen-rich pulmonary blood."), LessonStructure(name: "Left ventricle", function: "Pumps blood into the aorta.")]
        ),
        "heart-valves": LessonContent(
            overview: "Heart valves respond to pressure differences. They open when pressure behind them is greater and close when pressure begins to reverse, keeping blood moving forward through the chambers.",
            concepts: ["Atrioventricular valves lie between atria and ventricles.", "Semilunar valves guard the ventricular exits.", "Valve closure creates the normal heart sounds."],
            structures: [LessonStructure(name: "Tricuspid valve", function: "Controls flow from right atrium to right ventricle."), LessonStructure(name: "Pulmonary valve", function: "Guards the pulmonary artery."), LessonStructure(name: "Mitral valve", function: "Controls flow from left atrium to left ventricle."), LessonStructure(name: "Aortic valve", function: "Guards the entrance to the aorta.")]
        ),
        "heart-vessels": LessonContent(
            overview: "The great vessels connect the heart to the pulmonary and systemic circuits. Arteries carry blood away from the heart, while veins return blood to it, regardless of oxygen level.",
            concepts: ["The venae cavae return blood from the body.", "Pulmonary vessels connect the heart and lungs.", "The aorta distributes blood to systemic arteries."],
            structures: [LessonStructure(name: "Aorta", function: "Carries oxygen-rich blood to the body."), LessonStructure(name: "Venae cavae", function: "Return oxygen-poor blood from the body."), LessonStructure(name: "Pulmonary arteries", function: "Carry blood from the heart to the lungs."), LessonStructure(name: "Pulmonary veins", function: "Return oxygen-rich blood from the lungs.")]
        ),
        "heart-flow": LessonContent(
            overview: "Blood follows a continuous circuit: body, right heart, lungs, left heart, and body again. Valves and coordinated contractions maintain this one-way route.",
            concepts: ["Oxygen-poor blood enters the right atrium.", "Gas exchange in the lungs adds oxygen and removes carbon dioxide.", "Oxygen-rich blood leaves the left ventricle through the aorta."],
            structures: [LessonStructure(name: "Pulmonary circuit", function: "Moves blood between heart and lungs."), LessonStructure(name: "Systemic circuit", function: "Moves blood between heart and body."), LessonStructure(name: "Capillaries", function: "Allow exchange with tissues."), LessonStructure(name: "Valves", function: "Prevent reversal along the pathway.")]
        ),
        "brain-overview": LessonContent(
            overview: "The brain is the central control organ of the nervous system. It interprets sensory information, directs movement, supports thought and memory, and regulates essential internal functions.",
            concepts: ["Different regions specialise while working as a network.", "Neurons communicate with electrical and chemical signals.", "The skull, meninges, and cerebrospinal fluid protect the brain."],
            structures: [LessonStructure(name: "Cerebrum", function: "Supports perception, thought, and voluntary action."), LessonStructure(name: "Cerebellum", function: "Coordinates balance and movement."), LessonStructure(name: "Brain stem", function: "Regulates vital automatic functions."), LessonStructure(name: "Corpus callosum", function: "Connects the cerebral hemispheres.")]
        ),
        "brain-cerebrum": LessonContent(
            overview: "The cerebrum consists of right and left hemispheres covered by the cerebral cortex. Its lobes process sensation, plan actions, produce language, form memories, and support conscious thought.",
            concepts: ["The frontal lobe supports planning and voluntary movement.", "The parietal lobe processes body sensation and spatial information.", "Temporal and occipital regions support hearing, memory, and vision."],
            structures: [LessonStructure(name: "Frontal lobe", function: "Planning, behaviour, speech, and movement."), LessonStructure(name: "Parietal lobe", function: "Touch and spatial processing."), LessonStructure(name: "Temporal lobe", function: "Hearing, language, and memory."), LessonStructure(name: "Occipital lobe", function: "Visual processing.")]
        ),
        "brain-cerebellum": LessonContent(
            overview: "The cerebellum compares intended movement with sensory feedback. It adjusts timing, force, and coordination so actions become smooth and accurate rather than initiating movement itself.",
            concepts: ["It receives information from muscles, joints, eyes, and inner ears.", "It refines posture, balance, and motor learning.", "Damage can produce unsteady and poorly coordinated movement."],
            structures: [LessonStructure(name: "Hemispheres", function: "Coordinate limb movements."), LessonStructure(name: "Vermis", function: "Helps control posture and trunk movement."), LessonStructure(name: "Cerebellar cortex", function: "Processes incoming motor information."), LessonStructure(name: "Peduncles", function: "Connect the cerebellum with the brain stem.")]
        ),
        "brain-stem": LessonContent(
            overview: "The brain stem links the brain with the spinal cord. It carries major nerve pathways and regulates breathing, heart rate, blood pressure, alertness, swallowing, and protective reflexes.",
            concepts: ["The midbrain contributes to movement and visual reflexes.", "The pons connects regions and helps regulate breathing.", "The medulla controls vital cardiovascular and respiratory functions."],
            structures: [LessonStructure(name: "Midbrain", function: "Supports movement and sensory reflexes."), LessonStructure(name: "Pons", function: "Relays signals and assists breathing control."), LessonStructure(name: "Medulla", function: "Regulates vital automatic functions."), LessonStructure(name: "Reticular formation", function: "Supports wakefulness and attention.")]
        ),
        "lungs-overview": LessonContent(
            overview: "The lungs exchange gases between air and blood. Ventilation brings fresh air to microscopic alveoli, where oxygen enters capillaries and carbon dioxide moves into the air to be exhaled.",
            concepts: ["The right lung has three lobes and the left has two.", "Branching airways distribute air throughout each lung.", "The respiratory and circulatory systems work together."],
            structures: [LessonStructure(name: "Lobes", function: "Divide the lungs into anatomical regions."), LessonStructure(name: "Bronchial tree", function: "Conducts and distributes air."), LessonStructure(name: "Alveoli", function: "Provide the gas-exchange surface."), LessonStructure(name: "Pleura", function: "Reduces friction during breathing.")]
        ),
        "lungs-airways": LessonContent(
            overview: "Conducting airways form an inverted tree. The trachea divides into bronchi, which repeatedly branch into smaller bronchioles before reaching the respiratory zone.",
            concepts: ["Cartilage helps keep larger airways open.", "Mucus and cilia trap and remove inhaled particles.", "Smooth muscle changes bronchiole diameter and airflow resistance."],
            structures: [LessonStructure(name: "Trachea", function: "Carries air from the larynx to the bronchi."), LessonStructure(name: "Main bronchi", function: "Direct air into each lung."), LessonStructure(name: "Bronchioles", function: "Regulate and distribute airflow."), LessonStructure(name: "Cilia", function: "Move trapped debris toward the throat.")]
        ),
        "lungs-alveoli": LessonContent(
            overview: "Alveoli are tiny air sacs surrounded by dense capillary networks. Their thin, moist walls and enormous combined surface area allow gases to diffuse rapidly between air and blood.",
            concepts: ["Oxygen diffuses from alveolar air into blood.", "Carbon dioxide diffuses from blood into alveoli.", "Surfactant reduces surface tension and helps prevent collapse."],
            structures: [LessonStructure(name: "Type I cells", function: "Form most of the thin exchange surface."), LessonStructure(name: "Type II cells", function: "Produce pulmonary surfactant."), LessonStructure(name: "Capillaries", function: "Carry blood alongside alveolar air."), LessonStructure(name: "Alveolar macrophages", function: "Remove inhaled particles and microbes.")]
        ),
        "lungs-breathing": LessonContent(
            overview: "Breathing depends on pressure changes created by respiratory muscles. Increasing chest volume lowers pressure and draws air in; decreasing volume raises pressure and pushes air out.",
            concepts: ["The diaphragm contracts and descends during quiet inhalation.", "Elastic recoil normally drives quiet exhalation.", "Intercostal muscles move the ribs and assist ventilation."],
            structures: [LessonStructure(name: "Diaphragm", function: "Primary muscle of inhalation."), LessonStructure(name: "External intercostals", function: "Elevate ribs during inhalation."), LessonStructure(name: "Pleural cavity", function: "Couples lung movement to the chest wall."), LessonStructure(name: "Elastic tissue", function: "Helps lungs recoil during exhalation.")]
        )
    ]

    static let aorta = AnatomyStructure(
        id: "aorta",
        title: "Aorta",
        organTitle: "Heart",
        topic: "Major Vessels",
        pathway: "Left Ventricle → Aortic Valve → Systemic Arteries",
        functionDescription: "Carries oxygen-rich blood from the left ventricle to the body's systemic circulation.",
        tags: ["Left Ventricle", "Systemic Circulation"]
    )

    static let cerebellum = AnatomyStructure(
        id: "cerebellum",
        title: "Cerebellum",
        organTitle: "Brain",
        topic: "Hindbrain",
        pathway: "Sensory Input → Cerebellar Processing → Motor Coordination",
        functionDescription: "Coordinates balance, posture, motor learning, and the timing and precision of movement.",
        tags: ["Balance", "Movement"]
    )

    static let bronchi = AnatomyStructure(
        id: "bronchi",
        title: "Bronchi",
        organTitle: "Lungs",
        topic: "Airways",
        pathway: "Trachea → Main Bronchi → Bronchioles",
        functionDescription: "Conduct air from the trachea into each lung and branch to distribute it throughout the airways.",
        tags: ["Airways", "Respiration"]
    )

    static let aorticValve = AnatomyStructure(
        id: "aortic-valve",
        title: "Aortic Valve",
        organTitle: "Heart",
        topic: "Valves",
        pathway: "Left Ventricle → Aorta",
        functionDescription: "Opens during ventricular contraction and prevents blood flowing backward into the left ventricle.",
        tags: ["Left Ventricle", "Aorta"]
    )

    static let structures: [AnatomyStructure] = {
        var catalog = [aorta, cerebellum, bronchi, aorticValve]

        for organ in organs {
            for lesson in organ.lessons {
                guard let lessonContent = lessonContentByID[lesson.id] else { continue }

                for lessonStructure in lessonContent.structures {
                    let structure = structure(
                        for: lessonStructure,
                        lesson: lesson,
                        organID: organ.id
                    )

                    if !catalog.contains(where: { $0.id == structure.id }) {
                        catalog.append(structure)
                    }
                }
            }
        }

        return catalog
    }()

    static func structure(
        for lessonStructure: LessonStructure,
        lesson: AnatomyLesson,
        organID: String
    ) -> AnatomyStructure {
        switch (organID, lessonStructure.name.lowercased()) {
        case ("heart", "aorta"):
            return aorta
        case ("heart", "aortic valve"):
            return aorticValve
        case ("brain", "cerebellum"):
            return cerebellum
        default:
            break
        }

        let organ = organs.first(where: { $0.id == organID })
        let organTitle = organ?.title ?? organID.capitalized
        let slug = lessonStructure.name
            .lowercased()
            .split { !$0.isLetter && !$0.isNumber }
            .joined(separator: "-")

        return AnatomyStructure(
            id: "\(organID)-\(slug)",
            title: lessonStructure.name,
            organTitle: organTitle,
            topic: lesson.title,
            pathway: "\(organTitle) → \(lesson.title) → \(lessonStructure.name)",
            functionDescription: lessonStructure.function,
            tags: [organ?.systemName ?? organTitle, lesson.title]
        )
    }

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

    static let favourites = [aorta, cerebellum, bronchi]

    static var heart: Organ {
        organs[0]
    }
}
