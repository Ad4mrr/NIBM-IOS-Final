import SwiftUI

struct StartupSplashView: View {
    @Environment(\.accessibilityReduceMotion) private var accessibilityReduceMotion
    @State private var progress = 0.0

    let completion: () -> Void

    var body: some View {
        ZStack(alignment: .bottom) {
            AnatomyTheme.background
                .ignoresSafeArea()

            Image("LaunchArtwork")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()

            SplashLoadingBar(progress: progress)
                .padding(.horizontal, 48)
                .padding(.bottom, 42)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .statusBarHidden()
        .task {
            await Task.yield()

            if accessibilityReduceMotion {
                progress = 1
            } else {
                withAnimation(.easeInOut(duration: 1.8)) {
                    progress = 1
                }
            }

            try? await Task.sleep(for: .seconds(1.8))
            guard !Task.isCancelled else { return }
            completion()
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("AnatomyAR is loading")
        .accessibilityValue(Text(progress, format: .percent))
    }
}

private struct SplashLoadingBar: View {
    let progress: Double

    var body: some View {
        ProgressView(value: progress)
            .progressViewStyle(.linear)
            .tint(AnatomyTheme.teal)
            .background(.white.opacity(0.18), in: Capsule())
            .clipShape(Capsule())
            .frame(maxWidth: 420)
            .shadow(color: AnatomyTheme.teal.opacity(0.45), radius: 8)
    }
}

#Preview {
    StartupSplashView(completion: {})
}
