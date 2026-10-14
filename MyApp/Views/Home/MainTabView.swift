import SwiftUI

struct MainTabView: View {
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
        .tint(AnatomyTheme.teal)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    MainTabView()
}
