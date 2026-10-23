import SwiftUI

@main
struct AnatomyARApp: App {
    // appDelegate handles Firebase setup and notification callbacks
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
