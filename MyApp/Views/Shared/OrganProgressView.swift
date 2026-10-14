import SwiftUI

struct OrganProgressView: View {
    let title: String
    let symbolName: String
    let progress: Double
    let color: Color
    let completedLessons: Int
    let totalLessons: Int
    let bestQuizScore: Int

    private var safeProgress: Double {
        min(max(progress, 0), 1)
    }

    var body: some View {
        HStack(spacing: 20) {
            OrganFillSymbol(
                symbolName: symbolName,
                progress: safeProgress,
                color: color
            )

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(AnatomyTheme.textPrimary)

                Text(safeProgress, format: .percent.precision(.fractionLength(0)))
                    .font(.headline)
                    .foregroundStyle(color)

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
    let symbolName: String
    let progress: Double
    let color: Color

    var body: some View {
        ZStack {
            organSymbol
                .foregroundStyle(AnatomyTheme.incomplete)

            GeometryReader { geometry in
                organSymbol
                    .foregroundStyle(color)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    // The coloured copy is revealed from the bottom.
                    // Its height uses the same 0-to-1 value shown as progress text.
                    .mask(alignment: .bottom) {
                        Rectangle()
                            .frame(height: geometry.size.height * progress)
                    }
            }
        }
        .frame(width: 92, height: 92)
        .accessibilityHidden(true)
    }

    private var organSymbol: some View {
        Image(systemName: symbolName)
            .resizable()
            .scaledToFit()
            .padding(4)
    }
}

#Preview {
    OrganProgressView(
        title: "Heart",
        symbolName: "heart.fill",
        progress: 0.6,
        color: AnatomyTheme.heart,
        completedLessons: 3,
        totalLessons: 5,
        bestQuizScore: 80
    )
    .padding()
}
