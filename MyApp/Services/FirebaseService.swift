import FirebaseAuth
import FirebaseFirestore
import Foundation
import Observation

struct RemoteLearnerProfile {
    let learnerName: String
    let studyLevel: String
    let dailyGoalMinutes: Int
}

@MainActor
@Observable
final class FirebaseService {
    private(set) var isAuthenticated = false
    private(set) var isWorking = false
    private(set) var currentUserEmail: String?
    private(set) var errorMessage: String?

    @ObservationIgnored private var authStateHandle: AuthStateDidChangeListenerHandle?

    func startObservingAuthentication() {
        guard authStateHandle == nil else { return }

        let currentUser = Auth.auth().currentUser
        isAuthenticated = currentUser != nil
        currentUserEmail = currentUser?.email

        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor in
                self?.isAuthenticated = user != nil
                self?.currentUserEmail = user?.email
            }
        }
    }

    func signIn(email: String, password: String) async -> RemoteLearnerProfile? {
        guard validate(email: email, password: password) else { return nil }

        isWorking = true
        errorMessage = nil
        defer { isWorking = false }

        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            isAuthenticated = true
            currentUserEmail = result.user.email
            return try await fetchLearnerProfile(userID: result.user.uid)
        } catch {
            errorMessage = friendlyMessage(for: error)
            return nil
        }
    }

    func createAccount(
        name: String,
        email: String,
        password: String,
        studyLevel: String,
        dailyGoalMinutes: Int
    ) async -> Bool {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Please enter your name."
            return false
        }

        guard validate(email: email, password: password) else { return false }

        isWorking = true
        errorMessage = nil
        defer { isWorking = false }

        do {
            let result = try await Auth.auth().createUser(
                withEmail: email,
                password: password
            )

            try await saveLearnerProfile(
                userID: result.user.uid,
                name: name,
                email: email,
                studyLevel: studyLevel,
                dailyGoalMinutes: dailyGoalMinutes
            )

            isAuthenticated = true
            currentUserEmail = result.user.email
            return true
        } catch {
            errorMessage = friendlyMessage(for: error)
            return false
        }
    }

    func saveCurrentLearnerProfile(
        name: String,
        studyLevel: String,
        dailyGoalMinutes: Int
    ) async -> Bool {
        guard let user = Auth.auth().currentUser else {
            errorMessage = "Please sign in before saving your profile."
            return false
        }

        isWorking = true
        errorMessage = nil
        defer { isWorking = false }

        do {
            try await saveLearnerProfile(
                userID: user.uid,
                name: name,
                email: user.email ?? "",
                studyLevel: studyLevel,
                dailyGoalMinutes: dailyGoalMinutes
            )
            return true
        } catch {
            errorMessage = friendlyMessage(for: error)
            return false
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
            currentUserEmail = nil
            errorMessage = nil
        } catch {
            errorMessage = friendlyMessage(for: error)
        }
    }

    func clearError() {
        errorMessage = nil
    }

    func fetchCurrentLearnerProfile() async -> RemoteLearnerProfile? {
        guard let userID = Auth.auth().currentUser?.uid else { return nil }

        do {
            return try await fetchLearnerProfile(userID: userID)
        } catch {
            errorMessage = friendlyMessage(for: error)
            return nil
        }
    }

    private func fetchLearnerProfile(userID: String) async throws -> RemoteLearnerProfile? {
        let snapshot = try await Firestore.firestore()
            .collection("users")
            .document(userID)
            .getDocument()

        guard let data = snapshot.data() else { return nil }

        return RemoteLearnerProfile(
            learnerName: data["learnerName"] as? String ?? "Learner",
            studyLevel: data["studyLevel"] as? String ?? "Foundation",
            dailyGoalMinutes: data["dailyGoalMinutes"] as? Int ?? 10
        )
    }

    private func saveLearnerProfile(
        userID: String,
        name: String,
        email: String,
        studyLevel: String,
        dailyGoalMinutes: Int
    ) async throws {
        try await Firestore.firestore()
            .collection("users")
            .document(userID)
            .setData(
                [
                    "learnerName": name,
                    "email": email,
                    "studyLevel": studyLevel,
                    "dailyGoalMinutes": dailyGoalMinutes,
                    "updatedAt": FieldValue.serverTimestamp()
                ],
                merge: true
            )
    }

    private func validate(email: String, password: String) -> Bool {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)

        guard trimmedEmail.contains("@"), trimmedEmail.contains(".") else {
            errorMessage = "Please enter a valid email address."
            return false
        }

        guard password.count >= 6 else {
            errorMessage = "Password must contain at least 6 characters."
            return false
        }

        return true
    }

    private func friendlyMessage(for error: Error) -> String {
        let code = AuthErrorCode(rawValue: (error as NSError).code)

        switch code {
        case .emailAlreadyInUse:
            return "An account already exists for this email address."
        case .invalidEmail:
            return "Please enter a valid email address."
        case .weakPassword:
            return "Please choose a stronger password."
        case .wrongPassword, .invalidCredential:
            return "The email or password is incorrect."
        case .userNotFound:
            return "No account was found for this email address."
        case .networkError:
            return "Check your internet connection and try again."
        default:
            return error.localizedDescription
        }
    }
}
