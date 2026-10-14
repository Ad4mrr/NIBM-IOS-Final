import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house.fill") {
                NavigationStack {
                    HomeView()
                }
            }

            Tab("Learn", systemImage: "book.fill") {
                NavigationStack {
                    AnatomyLibraryView()
                }
            }

            Tab("AR", systemImage: "arkit") {
                NavigationStack {
                    ARPlaceholderView()
                }
            }

            Tab("Progress", systemImage: "chart.bar.fill") {
                NavigationStack {
                    ProgressDashboardView()
                }
            }
        }
        .tint(AnatomyTheme.teal)
    }
}

#Preview {
    MainTabView()
}
