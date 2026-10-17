import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    @State private var appState = AppState()
    @State private var firebaseService = FirebaseService()
    @State private var biometricService = BiometricService()

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
        .animation(.easeInOut(duration: 0.3), value: appState.route)
        .task {
            firebaseService.startObservingAuthentication()

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
