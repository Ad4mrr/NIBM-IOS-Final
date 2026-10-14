import SwiftUI

struct SettingsView: View {
    @Environment(AppState.self) private var appState
    @State private var useBiometrics = false
    @State private var largerStudyText = false

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
                Toggle("Use Face ID", isOn: $useBiometrics)
                Text("Visual placeholder only. Face ID logic is added in Phase 5.")
                    .font(.footnote)
                    .foregroundStyle(AnatomyTheme.textSecondary)
            }

            Section("Accessibility") {
                Toggle("Larger Study Text", isOn: $largerStudyText)
                Text("The interface already uses Dynamic Type text styles.")
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
                LabeledContent("Phase", value: "Static UI")
            }

            Section {
                Button("Sign Out", role: .destructive) {
                    appState.signOut()
                }
            }
        }
        .navigationTitle("Profile & Settings")
        .preferredColorScheme(.dark)
    }
}
