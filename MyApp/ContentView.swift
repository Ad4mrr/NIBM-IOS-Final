import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    @State private var appState = AppState()
    @State private var firebaseService = FirebaseService()
    @State private var biometricService = BiometricService()
    @State private var notificationService = NotificationService()
    @State private var studyActivityService = StudyActivityService()

    var body: some View {
        Group {
            switch appState.route {
            case .authentication:
                SplashView()
            case .main:
                if biometricService.isEnabled && !biometricService.isUnlocked {
                    BiometricLockView()
                } else {
                    MainTabView()
                }
            }
        }
        .environment(appState)
        .environment(firebaseService)
        .environment(biometricService)
        .environment(notificationService)
        .environment(studyActivityService)
        .animation(.easeInOut(duration: 0.3), value: appState.route)
        .task {
            firebaseService.startObservingAuthentication()
            await notificationService.refreshAuthorizationStatus()
            studyActivityService.refresh()

            if firebaseService.isAuthenticated {
                if let profile = await firebaseService.fetchCurrentLearnerProfile() {
                    appState.applyRemoteProfile(profile)
                }
                appState.route = .main
            }
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .background {
                biometricService.lock()
            }
        }
    }
}

#Preview {
    ContentView()
}
