import SwiftUI

struct OrganArtworkView: View {
    // reuses the same organ artwork across cards, headers and progress screens
    let organID: String
    var size: CGFloat = 180
    var showsGlow = true

    var body: some View {
        ZStack {
            if showsGlow {
                Circle()
                    .fill(AnatomyTheme.organColor(for: organID).opacity(0.22))
                    .frame(width: size * 0.82, height: size * 0.82)
                    .blur(radius: size * 0.18)
            }

            Image(AnatomyTheme.organImageName(for: organID))
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
                .accessibilityHidden(true)
        }
        .frame(width: size, height: size)
    }
}

struct SectionTitle: View {
    let eyebrow: String?
    let title: String
    let subtitle: String?

    init(_ title: String, eyebrow: String? = nil, subtitle: String? = nil) {
        self.title = title
        self.eyebrow = eyebrow
        self.subtitle = subtitle
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let eyebrow {
                Text(eyebrow.uppercased())
                    .font(.caption.weight(.bold))
                    .tracking(1.4)
                    .foregroundStyle(AnatomyTheme.teal)
            }

            Text(title)
                .font(.title2.weight(.bold))
                .foregroundStyle(AnatomyTheme.textPrimary)
                .accessibilityAddTraits(.isHeader)

            if let subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(AnatomyTheme.textSecondary)
            }
        }
    }
}
