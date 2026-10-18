import SwiftUI

struct ARPlaceholderView: View {
    @State private var selectedOrganID: String
    @State private var isPresentingAR = false

    init(initialOrganID: String = "heart") {
        let supportedOrgans = ["heart", "brain", "lungs"]
        _selectedOrganID = State(
            initialValue: supportedOrgans.contains(initialOrganID) ? initialOrganID : "heart"
        )
    }

    private var selectedOrgan: Organ {
        SampleAnatomyData.organs.first { $0.id == selectedOrganID } ?? SampleAnatomyData.heart
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                SectionTitle(
                    "Bring anatomy into your space",
                    eyebrow: "AR LAB · PHASE 7",
                    subtitle: "Choose an organ, scan a horizontal surface, then place and explore it."
                )

                ARModelPreview(organ: selectedOrgan)

                HStack(spacing: 10) {
                    ForEach(SampleAnatomyData.organs) { organ in
                        Button {
                            withAnimation(.snappy) {
                                selectedOrganID = organ.id
                            }
                        } label: {
                            VStack(spacing: 6) {
                                OrganArtworkView(organID: organ.id, size: 58, showsGlow: false)
                                Text(organ.title)
                                    .font(.caption.weight(.semibold))
                            }
                            .foregroundStyle(selectedOrganID == organ.id ? .white : AnatomyTheme.textSecondary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(
                                selectedOrganID == organ.id
                                    ? AnatomyTheme.organColor(for: organ.id).opacity(0.2)
                                    : AnatomyTheme.surface,
                                in: RoundedRectangle(cornerRadius: 18)
                            )
                            .overlay {
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(
                                        selectedOrganID == organ.id
                                            ? AnatomyTheme.organColor(for: organ.id).opacity(0.7)
                                            : .white.opacity(0.08)
                                    )
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }

                VStack(alignment: .leading, spacing: 15) {
                    Label("Interactive AR workflow", systemImage: "sparkles")
                        .font(.headline)
                        .foregroundStyle(AnatomyTheme.teal)
                    ARCapabilityRow(number: "01", title: "Scan", detail: "Find a horizontal surface")
                    ARCapabilityRow(number: "02", title: "Place", detail: "Tap the surface to position the organ")
                    ARCapabilityRow(number: "03", title: "Explore", detail: "Rotate, scale and open learning hotspots")
                }
                .anatomyCard()

                PrimaryButton("Start AR Experience", systemImage: "arkit") {
                    isPresentingAR = true
                }

                Text("Heart, Brain and Lungs use licensed anatomical models prepared for RealityKit. Models are for education, not diagnosis.")
                    .font(.footnote)
                    .foregroundStyle(AnatomyTheme.textSecondary)
            }
            .adaptiveContentWidth(900)
            .padding(20)
        }
        .navigationTitle("AR Lab")
        .navigationBarTitleDisplayMode(.inline)
        .anatomyScreenBackground()
        .fullScreenCover(isPresented: $isPresentingAR) {
            ARExperienceView(organID: selectedOrganID)
        }
    }
}

private struct ARModelPreview: View {
    let organ: Organ

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(AnatomyTheme.organGradient(for: organ.id))
            GridPattern()
                .opacity(0.12)
                .clipShape(RoundedRectangle(cornerRadius: 30))
            OrganArtworkView(organID: organ.id, size: 260)
            VStack {
                HStack {
                    StatusBadge(title: "MODEL PREVIEW", systemImage: "cube.transparent", color: .white)
                    Spacer()
                }
                Spacer()
                HStack {
                    VStack(alignment: .leading) {
                        Text(organ.title)
                            .font(.title2.weight(.bold))
                        Text("AR placement available")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.65))
                    }
                    Spacer()
                }
            }
            .padding(20)
        }
        .frame(height: 360)
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .overlay { RoundedRectangle(cornerRadius: 30).stroke(.white.opacity(0.12)) }
    }
}

private struct GridPattern: View {
    var body: some View {
        Canvas { context, size in
            var path = Path()
            for x in stride(from: 0.0, through: size.width, by: 24) {
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: size.height))
            }
            for y in stride(from: 0.0, through: size.height, by: 24) {
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))
            }
            context.stroke(path, with: .color(.white), lineWidth: 0.5)
        }
    }
}

private struct ARCapabilityRow: View {
    let number: String
    let title: String
    let detail: String

    var body: some View {
        HStack(spacing: 14) {
            Text(number)
                .font(.caption.monospaced().weight(.bold))
                .foregroundStyle(AnatomyTheme.teal)
                .frame(width: 34, height: 34)
                .background(AnatomyTheme.teal.opacity(0.12), in: Circle())
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.headline)
                Text(detail).font(.subheadline).foregroundStyle(AnatomyTheme.textSecondary)
            }
        }
    }
}
