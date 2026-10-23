import SwiftUI

@main
struct AnatomyARApp: App {
    // firebase and alert callbacks
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
