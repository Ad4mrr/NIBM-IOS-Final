import SwiftUI

struct ARPlaceholderView: View {
    var body: some View {
        VStack(spacing: 22) {
            Spacer()

            Image(systemName: "arkit")
                .font(.system(size: 80))
                .foregroundStyle(AnatomyTheme.teal)

            VStack(spacing: 8) {
                Text("Explore Anatomy in AR")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text("Heart and Brain model placement will be implemented in Phase 7.")
                    .foregroundStyle(AnatomyTheme.textSecondary)
                    .multilineTextAlignment(.center)
            }

            VStack(alignment: .leading, spacing: 12) {
                Label("Scan a flat surface", systemImage: "viewfinder")
                Label("Place an organ model", systemImage: "cube.fill")
                Label("Rotate, scale and tap labels", systemImage: "hand.draw.fill")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .anatomyCard()

            Spacer()

            PrimaryButton("AR Coming in Phase 7", systemImage: "arkit") { }
                .disabled(true)
                .opacity(0.6)
        }
        .padding()
        .navigationTitle("AR")
        .anatomyScreenBackground()
    }
}
