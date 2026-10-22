import Foundation
import Network
import Observation

@MainActor
@Observable
final class NetworkMonitor {
    private(set) var isConnected = true

    @ObservationIgnored private let monitor = NWPathMonitor()
    @ObservationIgnored private let queue = DispatchQueue(label: "com.anatomyar.network-monitor")
    @ObservationIgnored private var hasStarted = false

    func start() {
        guard !hasStarted else { return }
        hasStarted = true

        monitor.pathUpdateHandler = { [weak self] path in
            let isConnected = path.status == .satisfied
            // Network updates arrive on the monitor queue, but the UI reads this on the main actor.
            Task { @MainActor in
                self?.isConnected = isConnected
            }
        }
        monitor.start(queue: queue)
    }
}
