import Foundation
import Network
import Observation

@MainActor
@Observable
final class NetworkMonitor {
    // connection state only
    private(set) var isConnected = true

    @ObservationIgnored private let monitor = NWPathMonitor()
    @ObservationIgnored private let queue = DispatchQueue(label: "com.anatomyar.network-monitor")
    @ObservationIgnored private var hasStarted = false

    func start() {
        // live network check
        guard !hasStarted else { return }
        hasStarted = true

        monitor.pathUpdateHandler = { [weak self] path in
            let isConnected = path.status == .satisfied
            // ui update on main actor
            Task { @MainActor in
                self?.isConnected = isConnected
            }
        }
        monitor.start(queue: queue)
    }
}
