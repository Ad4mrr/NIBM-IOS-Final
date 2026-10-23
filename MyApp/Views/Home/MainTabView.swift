import SwiftUI

struct MainTabView: View {
    // separate history per tab
    @Environment(NetworkMonitor.self) private var networkMonitor

    var body: some View {
        TabView {
            Tab("Home", systemImage: "house.fill") {
                NavigationStack { HomeView() }
            }

            Tab("Learn", systemImage: "books.vertical.fill") {
                NavigationStack { AnatomyLibraryView() }
            }

            Tab("AR Lab", systemImage: "arkit") {
                NavigationStack { ARPlaceholderView() }
            }

            Tab("Progress", systemImage: "chart.xyaxis.line") {
                NavigationStack { ProgressDashboardView() }
            }
        }
        .tabViewStyle(.sidebarAdaptable)
        .defaultAdaptableTabBarPlacement(.sidebar)
        .tint(AnatomyTheme.teal)
        .preferredColorScheme(.dark)
        .safeAreaInset(edge: .top, spacing: 0) {
            // non-blocking offline msg
            if !networkMonitor.isConnected {
                Label("Offline — your study content and progress remain available", systemImage: "wifi.slash")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(.orange)
                    .accessibilityLabel("Offline. Your study content and progress remain available.")
            }
        }
        .animation(.easeInOut, value: networkMonitor.isConnected)
    }
}

#Preview {
    MainTabView()
}
