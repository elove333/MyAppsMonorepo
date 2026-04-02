import Foundation
import Combine
import BluetoothHelpers
import CoreAnalytics

@MainActor
final class DiagnosticsViewModel: ObservableObject {

    // MARK: - Published state

    @Published private(set) var isScanning = false
    @Published private(set) var isConnected = false
    @Published private(set) var deviceName: String?
    @Published private(set) var rpm: Double = 0
    @Published private(set) var speed: Double = 0
    @Published private(set) var coolantTemp: Double = 0
    @Published private(set) var throttle: Double = 0
    @Published var showError = false
    @Published private(set) var errorMessage: String?

    // MARK: - Private

    private let scanner = OBD2Scanner()
    private let stateMachine = ConnectionStateMachine()
    private var cancellables = Set<AnyCancellable>()

    init() {
        scanner.errorSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.showError(error)
            }
            .store(in: &cancellables)

        scanner.receivedDataSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.handleOBDData(data)
            }
            .store(in: &cancellables)
    }

    // MARK: - Actions

    func startScan() async {
        do {
            try await stateMachine.transition(to: .scanning)
            isScanning = true
            scanner.startScanning()

            // Simulate connecting to a device after a short delay
            try? await Task.sleep(for: .seconds(2))
            await simulateConnection()
        } catch {
            showError(error)
        }
    }

    func disconnect() async {
        scanner.disconnect()
        try? await stateMachine.transition(to: .disconnected)
        try? await stateMachine.transition(to: .idle)
        isConnected = false
        deviceName = nil
        resetMetrics()
    }

    // MARK: - Private

    private func simulateConnection() async {
        isScanning = false
        do {
            try await stateMachine.transition(to: .connecting)
            try await stateMachine.transition(to: .connected)
            isConnected = true
            deviceName = "OBD2-BT-4.0"
            startMockMetrics()
            await AnalyticsManager.shared.track(OBD2ConnectedEvent(deviceName: deviceName ?? ""))
        } catch {
            showError(error)
        }
    }

    /// Feeds mock OBD2 data to simulate live readings.
    private func startMockMetrics() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self, self.isConnected else {
                timer.invalidate()
                return
            }
            // Simulate RPM response
            let rpmResponse = Data([0x41, 0x0C, UInt8.random(in: 0x10...0x50), UInt8.random(in: 0...0xFF)])
            self.handleOBDData(rpmResponse)
        }
    }

    private func handleOBDData(_ data: Data) {
        if let rpm = PIDParser.parse(response: data, pid: .engineRPM) {
            self.rpm = rpm
        } else if let speed = PIDParser.parse(response: data, pid: .vehicleSpeed) {
            self.speed = speed
        } else if let temp = PIDParser.parse(response: data, pid: .coolantTemp) {
            self.coolantTemp = temp
        } else if let throttle = PIDParser.parse(response: data, pid: .throttlePosition) {
            self.throttle = throttle
        }
    }

    private func resetMetrics() {
        rpm = 0; speed = 0; coolantTemp = 0; throttle = 0
    }

    private func showError(_ error: Error) {
        errorMessage = error.localizedDescription
        showError = true
    }
}

// MARK: - Analytics

private struct OBD2ConnectedEvent: AnalyticsEvent {
    let name = "obd2_connected"
    let deviceName: String
    var parameters: [String: any Sendable] { ["device_name": deviceName] }
}
