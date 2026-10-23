import SwiftUI

struct StatusBadge: View {
    // small reusable label lesson progress states
    let title: String
    let systemImage: String
    var color: Color = AnatomyTheme.teal

    var body: some View {
        Label(title, systemImage: systemImage)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundStyle(color)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(color.opacity(0.14), in: Capsule())
            .overlay { Capsule().stroke(color.opacity(0.25)) }
    }
}
