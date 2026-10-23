import SwiftUI

struct EditProfileView: View {
    // temporary form values
    @Environment(AppState.self) private var appState
    @Environment(FirebaseService.self) private var firebaseService
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var studyLevel = "Foundation"
    @State private var dailyGoalMinutes = 10

    private let studyLevels = ["School", "Foundation", "Undergraduate", "General Interest"]

    var body: some View {
        Form {
            Section("Profile") {
                TextField("Name", text: $name)
                    .textContentType(.name)

                Picker("Study level", selection: $studyLevel) {
                    ForEach(studyLevels, id: \.self) { level in
                        Text(level).tag(level)
                    }
                }

                Stepper(
                    "Daily target: \(dailyGoalMinutes) minutes",
                    value: $dailyGoalMinutes,
                    in: 5...60,
                    step: 5
                )
            }

            if let errorMessage = firebaseService.errorMessage {
                Section {
                    Label(errorMessage, systemImage: "exclamationmark.triangle.fill")
                        .foregroundStyle(AnatomyTheme.heart)
                }
            }

            Section {
                Button("Save Profile") {
                    Task { await save() }
                }
                .disabled(firebaseService.isWorking)
            }
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            name = appState.learnerName
            studyLevel = appState.studyLevel
            dailyGoalMinutes = appState.dailyGoalMinutes
            firebaseService.clearError()
        }
    }

    private func save() async {
        // state update after firebase
        let saved = await firebaseService.updateCurrentAccountProfile(
            name: name,
            studyLevel: studyLevel,
            dailyGoalMinutes: dailyGoalMinutes
        )
        guard saved else { return }

        appState.learnerName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        appState.studyLevel = studyLevel
        appState.dailyGoalMinutes = dailyGoalMinutes
        dismiss()
    }
}

struct AccountSecurityView: View {
    // email password changes separate confirmation fields
    @Environment(FirebaseService.self) private var firebaseService

    @State private var email = ""
    @State private var emailPassword = ""
    @State private var passwordConfirmation = ""
    @State private var newPassword = ""

    var body: some View {
        Form {
            Section("Email") {
                // email changes current password reauthentication
                TextField("Email address", text: $email)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)

                SecureField("Current password", text: $emailPassword)
                    .textContentType(.password)

                Button("Update Email") {
                    Task {
                        if await firebaseService.updateCurrentEmail(
                            to: email,
                            currentPassword: emailPassword
                        ) {
                            emailPassword = ""
                        }
                    }
                }
                .disabled(firebaseService.isWorking || emailPassword.isEmpty)
            }

            Section("Password") {
                // password confirmation separate email form
                SecureField("Current password", text: $passwordConfirmation)
                    .textContentType(.password)
                SecureField("New password", text: $newPassword)
                    .textContentType(.newPassword)

                Button("Update Password") {
                    Task {
                        if await firebaseService.updateCurrentPassword(
                            to: newPassword,
                            currentPassword: passwordConfirmation
                        ) {
                            passwordConfirmation = ""
                            newPassword = ""
                        }
                    }
                }
                .disabled(firebaseService.isWorking || passwordConfirmation.isEmpty || newPassword.isEmpty)
            }

            Section {
                Button("Send Password Reset Email") {
                    Task {
                        await firebaseService.sendPasswordReset()
                    }
                }
                .disabled(firebaseService.isWorking)
            } footer: {
                Text("A reset link will be sent to your signed-in email address.")
            }

            if let successMessage = firebaseService.successMessage {
                Section {
                    Label(successMessage, systemImage: "checkmark.circle.fill")
                        .foregroundStyle(AnatomyTheme.teal)
                }
            }

            if let errorMessage = firebaseService.errorMessage {
                Section {
                    Label(errorMessage, systemImage: "exclamationmark.triangle.fill")
                        .foregroundStyle(AnatomyTheme.heart)
                }
            }
        }
        .navigationTitle("Email & Password")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            email = firebaseService.currentUserEmail ?? ""
            firebaseService.clearError()
        }
    }
}
