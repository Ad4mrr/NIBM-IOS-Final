import SwiftUI

struct AnatomyCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(18)
            .background(AnatomyTheme.surface, in: RoundedRectangle(cornerRadius: 20))
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.black.opacity(0.05))
            }
            .shadow(color: Color.black.opacity(0.05), radius: 10, y: 4)
    }
}

extension View {
    func anatomyCard() -> some View {
        modifier(AnatomyCardStyle())
    }

    func anatomyScreenBackground() -> some View {
        background(AnatomyTheme.background.ignoresSafeArea())
    }
}
