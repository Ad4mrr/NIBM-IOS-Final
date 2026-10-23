import ARKit
import RealityKit
import SwiftUI

struct ARExperienceView: View {
    // SwiftUI shows controls and RealityKit shows the organ
    let organID: String

    @Environment(\.dismiss) private var dismiss
    @State private var instruction = "Move your device slowly to find a table or floor."
    @State private var selectedHotspot: ARHotspot?
    @State private var resetID = UUID()
    @State private var isShowingHotspotGuide = false

    private var organName: String {
        switch organID {
        case "brain": "Brain"
        case "lungs": "Lungs"
        default: "Heart"
        }
    }

    private var availableHotspots: [ARHotspot] {
        // text shown in the guide and popup is kept separate from 3D placement
        ARHotspot.content(for: organID)
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

                    VStack(spacing: 2) {
                        Text(organName)
                        .font(.headline)
                        Text("\(availableHotspots.count) learning points")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
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

                Button {
                    isShowingHotspotGuide = true
                } label: {
                    Label("Explore \(availableHotspots.count) labelled parts", systemImage: "list.bullet.circle.fill")
                        .font(.subheadline.weight(.semibold))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(.ultraThinMaterial, in: Capsule())
                }
                .accessibilityHint("Shows all available anatomy hotspots")

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
        .sheet(isPresented: $isShowingHotspotGuide) {
            ARHotspotGuide(organName: organName, hotspots: availableHotspots)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
}

struct ARHotspot: Identifiable, Equatable {
    let id: String
    let title: String
    let detail: String

    static func content(for organID: String) -> [ARHotspot] {
        switch organID {
        case "brain":
            [
                ARHotspot(id: "cerebrum", title: "Cerebrum", detail: "The cerebrum supports thought, memory, sensation, language, and voluntary movement."),
                ARHotspot(id: "cerebellum", title: "Cerebellum", detail: "The cerebellum coordinates balance, posture, and precise movement."),
                ARHotspot(id: "brain-stem", title: "Brain Stem", detail: "The brain stem controls vital automatic functions such as breathing and heart rate."),
                ARHotspot(id: "frontal-lobe", title: "Frontal Lobe", detail: "The frontal lobe supports planning, decision-making, speech, and voluntary movement."),
                ARHotspot(id: "temporal-lobe", title: "Temporal Lobe", detail: "The temporal lobe helps process sound, language, emotion, and memory.")
            ]
        case "lungs":
            [
                ARHotspot(id: "trachea", title: "Trachea", detail: "The trachea carries air from the throat toward the left and right bronchi."),
                ARHotspot(id: "bronchi", title: "Bronchi", detail: "The main bronchi branch from the trachea and carry air into each lung."),
                ARHotspot(id: "left-lung", title: "Left Lung", detail: "The left lung has two lobes and leaves space for the heart."),
                ARHotspot(id: "right-lung", title: "Right Lung", detail: "The right lung has three lobes and is slightly larger than the left lung."),
                ARHotspot(id: "diaphragm", title: "Diaphragm", detail: "The diaphragm contracts and moves downward to draw air into the lungs.")
            ]
        default:
            [
                ARHotspot(id: "aorta", title: "Aorta", detail: "The aorta carries oxygen-rich blood from the left ventricle to the body."),
                ARHotspot(id: "left-ventricle", title: "Left Ventricle", detail: "The left ventricle pumps oxygen-rich blood through the aortic valve into the aorta."),
                ARHotspot(id: "right-atrium", title: "Right Atrium", detail: "The right atrium receives oxygen-poor blood returning from the body."),
                ARHotspot(id: "pulmonary-artery", title: "Pulmonary Artery", detail: "The pulmonary artery carries oxygen-poor blood from the heart to the lungs."),
                ARHotspot(id: "vena-cava", title: "Vena Cava", detail: "The venae cavae return oxygen-poor blood from the body to the right atrium.")
            ]
        }
    }
}

private struct ARHotspotGuide: View {
    let organName: String
    let hotspots: [ARHotspot]

    var body: some View {
        NavigationStack {
            List(hotspots) { hotspot in
                VStack(alignment: .leading, spacing: 5) {
                    Label(hotspot.title, systemImage: "scope")
                        .font(.headline)
                    Text(hotspot.detail)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("\(organName) hotspots")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private struct ARViewContainer: UIViewRepresentable {
    // this bridge lets the UIKit AR view live inside the SwiftUI screen
    let organID: String
    let resetID: UUID
    @Binding var instruction: String
    @Binding var selectedHotspot: ARHotspot?

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> ARView {
        // create the camera view once and attach gestures through the coordinator
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
        // SwiftUI calls this after selection or reset changes
        context.coordinator.parent = self
        context.coordinator.updateHotspotSelection()
        if context.coordinator.currentResetID != resetID {
            context.coordinator.currentResetID = resetID
            context.coordinator.startSession()
        }
    }

    static func dismantleUIView(_ arView: ARView, coordinator: Coordinator) {
        // stop the camera as soon as this screen is removed
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
            // horizontal plane detection looks for a table or floor
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
            // place the organ automatically on the first detected surface
            guard !hasDetectedPlane, anchors.contains(where: { $0 is ARPlaneAnchor }) else { return }
            hasDetectedPlane = true
            parent.instruction = "Surface found. Tap where you want to place the organ."
        }

        @objc
        func handleTap(_ recognizer: UITapGestureRecognizer) {
            // first try a direct entity hit, then use the larger screen-space area
            guard let arView else { return }
            let point = recognizer.location(in: arView)

            if let hotspot = hotspotNear(point, in: arView) {
                parent.selectedHotspot = hotspot
                return
            }

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
            // loading is async so the camera view stays responsive
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
            // walk up the entity tree because RealityKit may hit a child mesh
            var current: Entity? = entity
            while let candidate = current {
                let prefix = "hotspot-\(parent.organID)-"
                if candidate.name.hasPrefix(prefix) {
                    let hotspotID = String(candidate.name.dropFirst(prefix.count))
                    return ARHotspot.content(for: parent.organID).first { $0.id == hotspotID }
                }
                current = candidate.parent
            }
            return nil
        }

        private func hotspotNear(_ point: CGPoint, in arView: ARView) -> ARHotspot? {
            guard let placedEntity else { return nil }

            // keep a bigger tap area around each hotspot
            let prefix = "hotspot-\(parent.organID)-"
            let candidates: [(entity: Entity, distance: CGFloat)] = hotspotEntities(
                in: placedEntity,
                prefix: prefix
            ).compactMap { entity -> (entity: Entity, distance: CGFloat)? in
                guard let screenPoint = arView.project(entity.position(relativeTo: nil)) else {
                    return nil
                }

                let distance = hypot(screenPoint.x - point.x, screenPoint.y - point.y)
                return (entity: entity, distance: distance)
            }

            guard let closest = candidates.min(by: { $0.distance < $1.distance }),
                  closest.distance <= 52 else {
                return nil
            }

            return hotspot(for: closest.entity)
        }

        private func hotspotEntities(in entity: Entity, prefix: String) -> [Entity] {
            // recursively collect markers because they sit under the organ entity
            var matches = entity.name.hasPrefix(prefix) ? [entity] : []
            for child in entity.children {
                matches.append(contentsOf: hotspotEntities(in: child, prefix: prefix))
            }
            return matches
        }

        func updateHotspotSelection() {
            // cyan means available and yellow means currently selected
            guard let placedEntity else { return }

            let prefix = "hotspot-\(parent.organID)-"
            for entity in hotspotEntities(in: placedEntity, prefix: prefix) {
                guard let marker = entity as? ModelEntity,
                      var model = marker.components[ModelComponent.self] else {
                    continue
                }

                let hotspotID = String(entity.name.dropFirst(prefix.count))
                let isSelected = hotspotID == parent.selectedHotspot?.id
                model.materials = [
                    UnlitMaterial(color: isSelected ? .systemYellow : .cyan)
                ]
                marker.components.set(model)
                marker.scale = SIMD3(repeating: isSelected ? 1.3 : 1)
            }
        }
    }
}

@MainActor
private enum ARMedicalOrganFactory {
    static func makeOrgan(id: String) async throws -> ModelEntity {
        // load the matching USDZ file and prepare it for gestures and hotspots
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
        container.addChild(loadedEntity)

        addHotspots(
            for: id,
            modelExtents: bounds.extents * scale,
            to: container
        )
        container.generateCollisionShapes(recursive: true)
        return container
    }

    private static func applyTissueMaterial(to entity: Entity, organID: String) {
        // give every mesh the same organ colour while keeping realistic lighting
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

    private static func addHotspots(
        for organID: String,
        modelExtents: SIMD3<Float>,
        to parent: Entity
    ) {
        // convert easy-to-edit normalized coordinates into the model's real size
        // normalized positions work with different model sizes
        let halfExtents = modelExtents / 2

        for placement in hotspotPlacements(for: organID) {
            let position = SIMD3(
                placement.normalizedPosition.x * halfExtents.x,
                placement.normalizedPosition.y * halfExtents.y,
                placement.normalizedPosition.z * halfExtents.z
            )
            addHotspot(
                named: "hotspot-\(organID)-\(placement.id)",
                position: position,
                to: parent
            )
        }
    }

    private static func hotspotPlacements(for organID: String) -> [HotspotPlacement] {
        // values are [left/right, bottom/top, back/front] from roughly -1 to 1
        switch organID {
        case "brain":
            [
                HotspotPlacement(id: "cerebrum", normalizedPosition: [0.15, 0.54, 0.92]),
                HotspotPlacement(id: "cerebellum", normalizedPosition: [0, -0.50, -0.94]),
                HotspotPlacement(id: "brain-stem", normalizedPosition: [0, -0.88, -0.20]),
                HotspotPlacement(id: "frontal-lobe", normalizedPosition: [0.72, 0.30, 0.72]),
                HotspotPlacement(id: "temporal-lobe", normalizedPosition: [0.82, -0.20, 0.48])
            ]
        case "lungs":
            [
                HotspotPlacement(id: "trachea", normalizedPosition: [0, 0.88, 0.35]),
                HotspotPlacement(id: "bronchi", normalizedPosition: [0, 0.16, 0.92]),
                HotspotPlacement(id: "left-lung", normalizedPosition: [-0.72, 0.12, 0.82]),
                HotspotPlacement(id: "right-lung", normalizedPosition: [0.72, 0.12, 0.82]),
                HotspotPlacement(id: "diaphragm", normalizedPosition: [0, -0.92, 0.38])
            ]
        default:
            [
                HotspotPlacement(id: "aorta", normalizedPosition: [0.18, 0.90, 0.32]),
                HotspotPlacement(id: "left-ventricle", normalizedPosition: [-0.25, -0.38, 0.88]),
                HotspotPlacement(id: "right-atrium", normalizedPosition: [0.58, 0.18, 0.86]),
                HotspotPlacement(id: "pulmonary-artery", normalizedPosition: [-0.28, 0.62, 0.92]),
                HotspotPlacement(id: "vena-cava", normalizedPosition: [0.68, 0.66, 0.24])
            ]
        }
    }

    private static func addHotspot(named name: String, position: SIMD3<Float>, to parent: Entity) {
        // a larger invisible collision sphere makes the visible marker easier to tap
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

    private struct HotspotPlacement {
        let id: String
        let normalizedPosition: SIMD3<Float>
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
            named: "hotspot-heart-left-ventricle",
            position: [-0.02, -0.05, 0.055],
            to: root
        )
        addHotspot(named: "hotspot-heart-right-atrium", position: [0.04, 0.025, 0.05], to: root)
        addHotspot(named: "hotspot-heart-pulmonary-artery", position: [-0.025, 0.07, 0.05], to: root)
        addHotspot(named: "hotspot-heart-vena-cava", position: [0.05, 0.065, 0], to: root)
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
        addHotspot(named: "hotspot-brain-brain-stem", position: [0, -0.07, -0.025], to: root)
        addHotspot(named: "hotspot-brain-frontal-lobe", position: [0.055, 0.03, 0.04], to: root)
        addHotspot(named: "hotspot-brain-temporal-lobe", position: [0.06, -0.015, 0.025], to: root)
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
        addHotspot(named: "hotspot-lungs-left-lung", position: [-0.05, 0.015, 0.045], to: root)
        addHotspot(named: "hotspot-lungs-right-lung", position: [0.05, 0.015, 0.045], to: root)
        addHotspot(named: "hotspot-lungs-diaphragm", position: [0, -0.085, 0.025], to: root)
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
