import SwiftUI

struct BiometricLockView: View {
    @Environment(BiometricService.self) private var biometricService

    var body: some View {
        ZStack {
            AnatomyTheme.backgroundGradient
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Image(systemName: "faceid")
                    .font(.system(size: 72))
                    .foregroundStyle(AnatomyTheme.teal)
                    .accessibilityHidden(true)

                VStack(spacing: 8) {
                    Text("AnatomyAR is locked")
                        .font(.largeTitle.weight(.bold))
                        .multilineTextAlignment(.center)

                    Text("Use \(biometricService.biometryName) to continue your learning session.")
                        .foregroundStyle(AnatomyTheme.textSecondary)
                        .multilineTextAlignment(.center)
                }

                if let errorMessage = biometricService.errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundStyle(AnatomyTheme.heart)
                        .multilineTextAlignment(.center)
                }

                PrimaryButton(
                    "Unlock with \(biometricService.biometryName)",
                    systemImage: "faceid"
                ) {
                    Task {
                        await biometricService.unlock()
                    }
                }
            }
            .padding(28)
        }
        .task {
            await biometricService.unlock()
        }
    }
}
