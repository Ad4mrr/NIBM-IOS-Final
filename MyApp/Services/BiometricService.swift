import Foundation
import LocalAuthentication
import Observation

@MainActor
@Observable
final class BiometricService {
    // biometric setting and checks
    private static let enabledKey = "biometricUnlockEnabled"

    private(set) var isEnabled: Bool
    private(set) var isUnlocked: Bool
    private(set) var isAvailable = false
    private(set) var biometryName = "Biometrics"
    private(set) var errorMessage: String?

    init() {
        let storedValue = UserDefaults.standard.bool(forKey: Self.enabledKey)
        isEnabled = storedValue
        isUnlocked = !storedValue
        refreshAvailability()
    }

    func refreshAvailability() {
        let context = LAContext()
        var error: NSError?
        isAvailable = context.canEvaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            error: &error
        )

        switch context.biometryType {
        case .faceID:
            biometryName = "Face ID"
        case .touchID:
            biometryName = "Touch ID"
        case .opticID:
            biometryName = "Optic ID"
        case .none:
            biometryName = "Biometrics"
        @unknown default:
            biometryName = "Biometrics"
        }

        if !isAvailable, isEnabled {
            isUnlocked = true
            errorMessage = error?.localizedDescription
        }
    }

    func setEnabled(_ shouldEnable: Bool) async {
        // check before biometric enable
        errorMessage = nil

        if shouldEnable {
            guard isAvailable else {
                errorMessage = "\(biometryName) is not available or enrolled on this device."
                return
            }

            guard await authenticate(
                reason: "Enable \(biometryName) for faster access to your learning profile"
            ) else {
                return
            }
        }

        saveEnabledPreference(shouldEnable)
        isUnlocked = true
    }

    private func saveEnabledPreference(_ value: Bool) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: Self.enabledKey)

        // instant setting save
        // setting disk sync
        defaults.synchronize()
        isEnabled = defaults.bool(forKey: Self.enabledKey)
    }

    @discardableResult
    func unlock() async -> Bool {
        guard isEnabled else {
            isUnlocked = true
            return true
        }

        return await authenticate(
            reason: "Unlock your anatomy learning profile"
        )
    }

    func lock() {
        if isEnabled {
            isUnlocked = false
            errorMessage = nil
        }
    }

    private func authenticate(reason: String) async -> Bool {
        // biometric system sheet
        let context = LAContext()
        context.localizedCancelTitle = "Use account login"

        var availabilityError: NSError?
        guard context.canEvaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            error: &availabilityError
        ) else {
            errorMessage = availabilityError?.localizedDescription
                ?? "\(biometryName) is unavailable."
            return false
        }

        do {
            let succeeded = try await context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: reason
            )
            isUnlocked = succeeded
            errorMessage = succeeded ? nil : "Authentication was not successful."
            return succeeded
        } catch {
            let code = LAError.Code(rawValue: (error as NSError).code)

            if code != .userCancel && code != .systemCancel && code != .appCancel {
                errorMessage = error.localizedDescription
            }

            isUnlocked = false
            return false
        }
    }
}
