import SwiftUI

struct SettingsView: View {
    // settings links
    @Environment(AppState.self) private var appState
    @Environment(FirebaseService.self) private var firebaseService
    @Environment(BiometricService.self) private var biometricService
    @State private var isShowingResetConfirmation = false

    var body: some View {
        List {
            Section {
                HStack(spacing: 14) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 52))
                        .foregroundStyle(AnatomyTheme.teal)

                    VStack(alignment: .leading) {
                        Text(appState.learnerName)
                            .font(.headline)
                        Text("\(appState.studyLevel) learner")
                            .font(.subheadline)
                            .foregroundStyle(AnatomyTheme.textSecondary)
                    }
                }
                .padding(.vertical, 6)

                NavigationLink("Edit Profile") {
                    EditProfileView()
                }
            }

            Section("Study") {
                NavigationLink("Study Reminder") {
                    ReminderSetupView()
                }

                NavigationLink("Saved Structures") {
                    FavouritesView()
                }

            Button("Reset Study Progress", role: .destructive) {
                // reset confirmation
                isShowingResetConfirmation = true
                }
            }

            Section("Security") {
                // separate account security
                NavigationLink("Email & Password") {
                    AccountSecurityView()
                }

                Toggle(
                    "Use \(biometricService.biometryName)",
                    isOn: Binding(
                        get: { biometricService.isEnabled },
                        set: { shouldEnable in
                            // biometric check on enable
                            Task {
                                await biometricService.setEnabled(shouldEnable)
                            }
                        }
                    )
                )
                .disabled(!biometricService.isAvailable)

                if let errorMessage = biometricService.errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundStyle(AnatomyTheme.heart)
                } else {
                    Text(
                        !biometricService.isAvailable
                            ? "Biometric authentication is unavailable or not enrolled."
                            : biometricService.isEnabled
                                ? "\(biometricService.biometryName) unlock is enabled and saved."
                                : "Require \(biometricService.biometryName) when reopening the app."
                    )
                    .font(.footnote)
                    .foregroundStyle(AnatomyTheme.textSecondary)
                }
            }

            Section("Accessibility") {
                Label("Dynamic Type supported", systemImage: "textformat.size")
                Text("Choose your preferred text size in iPhone or iPad Settings. AnatomyAR follows that system setting automatically.")
                    .font(.footnote)
                    .foregroundStyle(AnatomyTheme.textSecondary)
            }

            Section("About") {
                LabeledContent("Application", value: "AnatomyAR")
            }

            Section {
                Button("Sign Out", role: .destructive) {
                    firebaseService.signOut()
                    appState.signOut()
                }
            }
        }
        .navigationTitle("Profile & Settings")
        .preferredColorScheme(.dark)
        .confirmationDialog(
            "Reset all study progress?",
            isPresented: $isShowingResetConfirmation,
            titleVisibility: .visible
        ) {
            Button("Reset Study Progress", role: .destructive) {
                appState.resetStudyProgress()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Completed lessons and best quiz scores will be cleared. Your profile and saved structures will remain.")
        }
    }
}
