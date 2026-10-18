import SwiftUI

struct SettingsView: View {
    @Environment(AppState.self) private var appState
    @Environment(FirebaseService.self) private var firebaseService
    @Environment(BiometricService.self) private var biometricService

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
            }

            Section("Study") {
                NavigationLink("Study Reminder") {
                    ReminderSetupView()
                }

                NavigationLink("Saved Structures") {
                    FavouritesView()
                }
            }

            Section("Security") {
                Toggle(
                    "Use \(biometricService.biometryName)",
                    isOn: Binding(
                        get: { biometricService.isEnabled },
                        set: { shouldEnable in
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

            Section("Phase 1 State Previews") {
                NavigationLink("Loading") {
                    LoadingStateView()
                }
                NavigationLink("Backend Error") {
                    BackendErrorView()
                }
                NavigationLink("Offline") {
                    OfflineStateView()
                }
            }

            Section("About") {
                LabeledContent("Application", value: "AnatomyAR")
                LabeledContent("Phase", value: "Notifications")
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
    }
}
