import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    @State private var appState = AppState()
    @State private var firebaseService = FirebaseService()
    @State private var biometricService = BiometricService()
    @State private var notificationService = NotificationService()
    @State private var studyActivityService = StudyActivityService()
    @State private var networkMonitor = NetworkMonitor()
    @State private var isShowingStartupSplash = true

    var body: some View {
        ZStack {
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

            if isShowingStartupSplash {
                StartupSplashView {
                    withAnimation(.easeOut(duration: 0.35)) {
                        isShowingStartupSplash = false
                    }
                }
                .transition(.opacity)
                .zIndex(1)
            }
        }
        .environment(appState)
        .environment(firebaseService)
        .environment(biometricService)
        .environment(notificationService)
        .environment(studyActivityService)
        .environment(networkMonitor)
        .animation(.easeInOut(duration: 0.3), value: appState.route)
        .task {
            firebaseService.startObservingAuthentication()
            networkMonitor.start()
            await notificationService.refreshAuthorizationStatus()
            studyActivityService.refresh()

            if firebaseService.isAuthenticated {
                if let profile = await firebaseService.fetchCurrentLearnerProfile() {
                    appState.applyRemoteProfile(profile)
                }
                await synchronizeStudyProgress()
                appState.route = .main
            }
        }
        .onChange(of: appState.studyProgressSnapshot) { _, progress in
            guard firebaseService.isAuthenticated else { return }
            Task {
                await firebaseService.saveCurrentStudyProgress(progress)
            }
        }
        .onChange(of: firebaseService.isAuthenticated) { wasAuthenticated, isAuthenticated in
            guard isAuthenticated, !wasAuthenticated else { return }
            Task {
                await synchronizeStudyProgress()
            }
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .background {
                biometricService.lock()
            }
        }
    }

    private func synchronizeStudyProgress() async {
        if let remote = await firebaseService.synchronizeStudyProgress(
            local: appState.studyProgressSnapshot
        ) {
            appState.applyRemoteStudyProgress(remote)
        }
    }
}

#Preview {
    ContentView()
}
