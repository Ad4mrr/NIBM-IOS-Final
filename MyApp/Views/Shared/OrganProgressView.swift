import SwiftUI

struct OrganProgressView: View {
    let title: String
    let organID: String
    let progress: Double
    let color: Color
    let completedLessons: Int
    let totalLessons: Int
    let bestQuizScore: Int

    private var safeProgress: Double {
        min(max(progress, 0), 1)
    }

    var body: some View {
        HStack(spacing: 18) {
            OrganFillSymbol(
                organID: organID,
                progress: safeProgress,
                color: color
            )

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(AnatomyTheme.textPrimary)

                HStack {
                    Text(safeProgress, format: .percent.precision(.fractionLength(0)))
                        .font(.title3.weight(.bold))
                        .foregroundStyle(color)
                    Text("complete")
                        .foregroundStyle(AnatomyTheme.textSecondary)
                }

                Text("\(completedLessons) of \(totalLessons) lessons completed")
                Text("Best Quiz: \(bestQuizScore)%")
            }
            .font(.subheadline)
            .foregroundStyle(AnatomyTheme.textSecondary)

            Spacer(minLength: 0)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(title), \(Int(safeProgress * 100)) percent complete, \(completedLessons) of \(totalLessons) lessons completed, best quiz \(bestQuizScore) percent")
    }
}

private struct OrganFillSymbol: View {
    let organID: String
    let progress: Double
    let color: Color

    var body: some View {
        ZStack {
            organArtwork
                .grayscale(1)
                .opacity(0.42)

            GeometryReader { geometry in
                organArtwork
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .mask(alignment: .bottom) {
                        Rectangle()
                            .frame(height: geometry.size.height * progress)
                    }
            }
        }
        .frame(width: 84, height: 84)
        .background(color.opacity(0.1), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .accessibilityHidden(true)
    }

    private var organArtwork: some View {
        Image(AnatomyTheme.organImageName(for: organID))
            .resizable()
            .scaledToFit()
            .padding(2)
    }
}

#Preview {
    OrganProgressView(
        title: "Heart",
        organID: "heart",
        progress: 0.6,
        color: AnatomyTheme.heart,
        completedLessons: 3,
        totalLessons: 5,
        bestQuizScore: 80
    )
    .padding()
}
