import SwiftUI

struct ContentView: View {
    @State private var appState = AppState()

    var body: some View {
        Group {
            switch appState.route {
            case .authentication:
                SplashView()
            case .main:
                MainTabView()
            }
        }
        .environment(appState)
        .animation(.easeInOut(duration: 0.3), value: appState.route)
    }
}

#Preview {
    ContentView()
}
