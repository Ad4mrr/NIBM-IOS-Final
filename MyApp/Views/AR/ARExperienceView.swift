import ARKit
import RealityKit
import SwiftUI

struct ARExperienceView: View {
    let organID: String

    @Environment(\.dismiss) private var dismiss
    @State private var instruction = "Move your device slowly to find a table or floor."
    @State private var selectedHotspot: ARHotspot?
    @State private var resetID = UUID()

    private var organName: String {
        switch organID {
        case "brain": "Brain"
        case "lungs": "Lungs"
        default: "Heart"
        }
    }

    var body: some View {
        ZStack {
            if ARWorldTrackingConfiguration.isSupported {
                ARViewContainer(
                    organID: organID,
                    resetID: resetID,
                    instruction: $instruction,
                    selectedHotspot: $selectedHotspot
                )
                .ignoresSafeArea()
            } else {
                ContentUnavailableView(
                    "AR unavailable",
                    systemImage: "arkit",
                    description: Text("Use a physical iPhone or iPad that supports ARKit.")
                )
            }

            VStack(spacing: 12) {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.headline)
                            .frame(width: 44, height: 44)
                            .background(.ultraThinMaterial, in: Circle())
                    }
                    .accessibilityLabel("Close AR viewer")

                    Spacer()

                    Text(organName)
                        .font(.headline)
                        .padding(.horizontal, 16)
                        .frame(height: 44)
                        .background(.ultraThinMaterial, in: Capsule())

                    Spacer()

                    Button {
                        selectedHotspot = nil
                        instruction = "Move your device slowly to find a table or floor."
                        resetID = UUID()
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.headline)
                            .frame(width: 44, height: 44)
                            .background(.ultraThinMaterial, in: Circle())
                    }
                    .accessibilityLabel("Reset AR scene")
                }

                Text(instruction)
                    .font(.subheadline.weight(.semibold))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(.ultraThinMaterial, in: Capsule())

                Spacer()

                if let selectedHotspot {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(selectedHotspot.title)
                                .font(.headline)
                            Spacer()
                            Button {
                                self.selectedHotspot = nil
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                            }
                            .accessibilityLabel("Close hotspot information")
                        }
                        Text(selectedHotspot.detail)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 18))
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                Label("Pinch to scale · Twist to rotate · Tap a glowing point", systemImage: "hand.draw")
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 9)
                    .background(.ultraThinMaterial, in: Capsule())
            }
            .padding()
        }
        .preferredColorScheme(.dark)
        .animation(.easeInOut, value: selectedHotspot)
    }
}

struct ARHotspot: Equatable {
    let title: String
    let detail: String
}

private struct ARViewContainer: UIViewRepresentable {
    let organID: String
    let resetID: UUID
    @Binding var instruction: String
    @Binding var selectedHotspot: ARHotspot?

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        context.coordinator.arView = arView
        arView.session.delegate = context.coordinator
        arView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: context.coordinator,
                action: #selector(Coordinator.handleTap(_:))
            )
        )
        context.coordinator.startSession()
        return arView
    }

    func updateUIView(_ arView: ARView, context: Context) {
        context.coordinator.parent = self
        if context.coordinator.currentResetID != resetID {
            context.coordinator.currentResetID = resetID
            context.coordinator.startSession()
        }
    }

    static func dismantleUIView(_ arView: ARView, coordinator: Coordinator) {
        arView.session.pause()
    }

    @MainActor
    final class Coordinator: NSObject, ARSessionDelegate {
        var parent: ARViewContainer
        weak var arView: ARView?
        var currentResetID: UUID
        private var hasDetectedPlane = false
        private var placedEntity: ModelEntity?
        private var isLoadingModel = false

        init(parent: ARViewContainer) {
            self.parent = parent
            currentResetID = parent.resetID
        }

        func startSession() {
            guard let arView else { return }

            placedEntity = nil
            isLoadingModel = false
            hasDetectedPlane = false
            arView.scene.anchors.removeAll()

            let configuration = ARWorldTrackingConfiguration()
            configuration.planeDetection = [.horizontal]
            configuration.environmentTexturing = .automatic
            arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        }

        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
            guard !hasDetectedPlane, anchors.contains(where: { $0 is ARPlaneAnchor }) else { return }
            hasDetectedPlane = true
            parent.instruction = "Surface found. Tap where you want to place the organ."
        }

        @objc
        func handleTap(_ recognizer: UITapGestureRecognizer) {
            guard let arView else { return }
            let point = recognizer.location(in: arView)

            if let tappedEntity = arView.entity(at: point),
               let hotspot = hotspot(for: tappedEntity) {
                parent.selectedHotspot = hotspot
                return
            }

            guard placedEntity == nil, !isLoadingModel else { return }

            let results = arView.raycast(
                from: point,
                allowing: .existingPlaneGeometry,
                alignment: .horizontal
            )
            guard let result = results.first else {
                parent.instruction = "No surface at that point. Keep scanning and try again."
                return
            }

            loadAndPlaceOrgan(at: result.worldTransform)
        }

        private func loadAndPlaceOrgan(at transform: simd_float4x4) {
            guard let arView else { return }

            isLoadingModel = true
            parent.instruction = "Loading detailed \(parent.organID) model…"

            Task { @MainActor in
                let organ: ModelEntity
                do {
                    organ = try await ARMedicalOrganFactory.makeOrgan(id: parent.organID)
                } catch {
                    organ = ARProceduralOrganFactory.makeOrgan(id: parent.organID)
                    parent.instruction = "The detailed model could not load. Showing the basic fallback."
                }

                guard self.currentResetID == self.parent.resetID else { return }

                let anchor = AnchorEntity(world: transform)
                anchor.addChild(organ)
                arView.scene.addAnchor(anchor)
                arView.installGestures([.rotation, .scale], for: organ)

                self.placedEntity = organ
                self.isLoadingModel = false
                if self.parent.instruction.hasPrefix("Loading") {
                    self.parent.instruction = "Organ placed. Rotate, scale, or tap a glowing hotspot."
                }
            }
        }

        private func hotspot(for entity: Entity) -> ARHotspot? {
            var current: Entity? = entity
            while let candidate = current {
                switch candidate.name {
                case "hotspot-heart-aorta":
                    return ARHotspot(
                        title: "Aorta",
                        detail: "The aorta carries oxygen-rich blood from the left ventricle to the body."
                    )
                case "hotspot-heart-ventricle":
                    return ARHotspot(
                        title: "Ventricle",
                        detail: "The ventricles are the lower chambers that pump blood out of the heart."
                    )
                case "hotspot-brain-cerebrum":
                    return ARHotspot(
                        title: "Cerebrum",
                        detail: "The cerebrum supports thought, memory, sensation, and voluntary movement."
                    )
                case "hotspot-brain-cerebellum":
                    return ARHotspot(
                        title: "Cerebellum",
                        detail: "The cerebellum helps coordinate balance, posture, and precise movement."
                    )
                case "hotspot-lungs-trachea":
                    return ARHotspot(
                        title: "Trachea",
                        detail: "The trachea carries air from the throat toward the left and right bronchi."
                    )
                case "hotspot-lungs-bronchi":
                    return ARHotspot(
                        title: "Bronchi",
                        detail: "The main bronchi branch from the trachea and carry air into each lung."
                    )
                default:
                    current = candidate.parent
                }
            }
            return nil
        }
    }
}

@MainActor
private enum ARMedicalOrganFactory {
    static func makeOrgan(id: String) async throws -> ModelEntity {
        let assetName: String
        switch id {
        case "brain": assetName = "Brain"
        case "lungs": assetName = "Lungs"
        default: assetName = "Heart"
        }

        let loadedEntity = try await Entity(named: assetName)
        let bounds = loadedEntity.visualBounds(relativeTo: loadedEntity)
        let largestDimension = max(bounds.extents.x, bounds.extents.y, bounds.extents.z)
        guard largestDimension > 0 else {
            throw ARModelError.invalidBounds
        }

        let container = ModelEntity()
        container.name = "\(id)-medical-model"

        let scale = Float(0.20) / largestDimension
        loadedEntity.scale = SIMD3(repeating: scale)
        loadedEntity.position = -bounds.center * scale
        applyTissueMaterial(to: loadedEntity, organID: id)
        container.addChild(loadedEntity)

        addHotspots(for: id, to: container)
        container.generateCollisionShapes(recursive: true)
        return container
    }

    private static func applyTissueMaterial(to entity: Entity, organID: String) {
        var material = PhysicallyBasedMaterial()
        material.baseColor = .init(tint: tissueColor(for: organID))
        material.roughness = .init(floatLiteral: organID == "brain" ? 0.62 : 0.48)
        material.metallic = .init(floatLiteral: 0)
        material.clearcoat = .init(floatLiteral: 0.18)
        material.clearcoatRoughness = .init(floatLiteral: 0.42)

        if var updatedComponent = entity.components[ModelComponent.self] {
            updatedComponent.materials = Array(
                repeating: material,
                count: max(updatedComponent.materials.count, 1)
            )
            entity.components.set(updatedComponent)
        }

        for child in entity.children {
            applyTissueMaterial(to: child, organID: organID)
        }
    }

    private static func tissueColor(for organID: String) -> UIColor {
        switch organID {
        case "brain":
            UIColor(red: 0.76, green: 0.48, blue: 0.47, alpha: 1)
        case "lungs":
            UIColor(red: 0.72, green: 0.32, blue: 0.36, alpha: 1)
        default:
            UIColor(red: 0.55, green: 0.06, blue: 0.08, alpha: 1)
        }
    }

    private static func addHotspots(for organID: String, to parent: Entity) {
        switch organID {
        case "brain":
            addHotspot(named: "hotspot-brain-cerebrum", position: [0.03, 0.075, 0.055], to: parent)
            addHotspot(named: "hotspot-brain-cerebellum", position: [0, -0.055, -0.07], to: parent)
        case "lungs":
            addHotspot(named: "hotspot-lungs-trachea", position: [0, 0.085, 0.025], to: parent)
            addHotspot(named: "hotspot-lungs-bronchi", position: [0, 0.015, 0.055], to: parent)
        default:
            addHotspot(named: "hotspot-heart-aorta", position: [0.02, 0.095, 0.025], to: parent)
            addHotspot(named: "hotspot-heart-ventricle", position: [0, -0.055, 0.06], to: parent)
        }
    }

    private static func addHotspot(named name: String, position: SIMD3<Float>, to parent: Entity) {
        let hotspot = ModelEntity(
            mesh: .generateSphere(radius: 0.008),
            materials: [UnlitMaterial(color: .cyan)]
        )
        hotspot.name = name
        hotspot.position = position
        parent.addChild(hotspot)
    }

    private enum ARModelError: Error {
        case invalidBounds
    }
}

@MainActor
private enum ARProceduralOrganFactory {
    static func makeOrgan(id: String) -> ModelEntity {
        switch id {
        case "brain": makeBrain()
        case "lungs": makeLungs()
        default: makeHeart()
        }
    }

    private static func makeHeart() -> ModelEntity {
        let red = SimpleMaterial(color: .systemRed, roughness: 0.42, isMetallic: false)
        let root = ModelEntity(
            mesh: .generateSphere(radius: 0.055),
            materials: [red]
        )
        root.name = "heart-model"
        root.scale = [1.0, 1.18, 0.82]

        let leftLobe = ModelEntity(mesh: .generateSphere(radius: 0.045), materials: [red])
        leftLobe.position = [-0.035, 0.025, 0]
        root.addChild(leftLobe)

        let rightLobe = ModelEntity(mesh: .generateSphere(radius: 0.045), materials: [red])
        rightLobe.position = [0.035, 0.025, 0]
        root.addChild(rightLobe)

        let vessel = ModelEntity(
            mesh: .generateCylinder(height: 0.075, radius: 0.012),
            materials: [SimpleMaterial(color: .systemPink, isMetallic: false)]
        )
        vessel.position = [0.018, 0.075, 0]
        root.addChild(vessel)

        addHotspot(
            named: "hotspot-heart-aorta",
            position: [0.02, 0.115, 0],
            to: root
        )
        addHotspot(
            named: "hotspot-heart-ventricle",
            position: [0, -0.05, 0.055],
            to: root
        )
        root.generateCollisionShapes(recursive: true)
        return root
    }

    private static func makeBrain() -> ModelEntity {
        let purple = SimpleMaterial(color: .systemPurple, roughness: 0.7, isMetallic: false)
        let root = ModelEntity(mesh: .generateSphere(radius: 0.065), materials: [purple])
        root.name = "brain-model"
        root.scale = [1.2, 0.82, 0.95]

        for x in [-0.045 as Float, 0.045] {
            for y in [-0.025 as Float, 0.025] {
                let lobe = ModelEntity(mesh: .generateSphere(radius: 0.045), materials: [purple])
                lobe.position = [x, y, 0]
                root.addChild(lobe)
            }
        }

        let cerebellum = ModelEntity(
            mesh: .generateSphere(radius: 0.035),
            materials: [SimpleMaterial(color: .systemIndigo, isMetallic: false)]
        )
        cerebellum.position = [0, -0.045, -0.05]
        root.addChild(cerebellum)

        addHotspot(
            named: "hotspot-brain-cerebrum",
            position: [0.02, 0.065, 0.045],
            to: root
        )
        addHotspot(
            named: "hotspot-brain-cerebellum",
            position: [0, -0.055, -0.08],
            to: root
        )
        root.generateCollisionShapes(recursive: true)
        return root
    }

    private static func makeLungs() -> ModelEntity {
        let material = SimpleMaterial(color: .systemPink, roughness: 0.55, isMetallic: false)
        let root = ModelEntity()
        root.name = "lungs-model"

        let left = ModelEntity(mesh: .generateSphere(radius: 0.055), materials: [material])
        left.scale = [0.72, 1.25, 0.68]
        left.position = [-0.047, 0, 0]
        root.addChild(left)

        let right = ModelEntity(mesh: .generateSphere(radius: 0.055), materials: [material])
        right.scale = [0.72, 1.25, 0.68]
        right.position = [0.047, 0, 0]
        root.addChild(right)

        addHotspot(named: "hotspot-lungs-trachea", position: [0, 0.09, 0.02], to: root)
        addHotspot(named: "hotspot-lungs-bronchi", position: [0, 0.015, 0.06], to: root)
        root.generateCollisionShapes(recursive: true)
        return root
    }

    private static func addHotspot(
        named name: String,
        position: SIMD3<Float>,
        to parent: Entity
    ) {
        let hotspot = ModelEntity(
            mesh: .generateSphere(radius: 0.012),
            materials: [UnlitMaterial(color: .cyan)]
        )
        hotspot.name = name
        hotspot.position = position
        parent.addChild(hotspot)
    }
}
