import Foundation
import Network
import Observation

@MainActor
@Observable
final class NetworkMonitor {
    // only connection state is exposed because study content already works offline
    private(set) var isConnected = true

    @ObservationIgnored private let monitor = NWPathMonitor()
    @ObservationIgnored private let queue = DispatchQueue(label: "com.anatomyar.network-monitor")
    @ObservationIgnored private var hasStarted = false

    func start() {
        // NWPathMonitor keeps checking the connection
        guard !hasStarted else { return }
        hasStarted = true

        monitor.pathUpdateHandler = { [weak self] path in
            let isConnected = path.status == .satisfied
            // update the UI on the main actor
            Task { @MainActor in
                self?.isConnected = isConnected
            }
        }
        monitor.start(queue: queue)
    }
}
