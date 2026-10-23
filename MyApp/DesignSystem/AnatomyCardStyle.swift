import SwiftUI

struct AnatomyCardStyle: ViewModifier {
    // common card surface
    func body(content: Content) -> some View {
        content
            .padding(18)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(Color.white.opacity(0.1))
            }
            .shadow(color: Color.black.opacity(0.22), radius: 20, y: 12)
    }
}

extension View {
    func anatomyCard() -> some View {
        modifier(AnatomyCardStyle())
    }

    func anatomyScreenBackground() -> some View {
        background(AnatomyTheme.backgroundGradient.ignoresSafeArea())
            .preferredColorScheme(.dark)
    }

    func adaptiveContentWidth(_ maxWidth: CGFloat = 1_000) -> some View {
        frame(maxWidth: maxWidth)
            .frame(maxWidth: .infinity)
    }
}
