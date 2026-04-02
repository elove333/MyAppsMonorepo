import XCTest
@testable import BluetoothHelpers

final class ConnectionStateMachineTests: XCTestCase {

    func testInitialStateIsIdle() async {
        let machine = ConnectionStateMachine()
        let state = await machine.state
        guard case .idle = state else {
            XCTFail("Expected initial state to be .idle")
            return
        }
    }

    func testValidTransitionIdleToScanning() async throws {
        let machine = ConnectionStateMachine()
        try await machine.transition(to: .scanning)
        let state = await machine.state
        guard case .scanning = state else {
            XCTFail("Expected .scanning after transition")
            return
        }
    }

    func testValidTransitionScanningToConnecting() async throws {
        let machine = ConnectionStateMachine()
        try await machine.transition(to: .scanning)
        try await machine.transition(to: .connecting)
        let state = await machine.state
        guard case .connecting = state else {
            XCTFail("Expected .connecting")
            return
        }
    }

    func testFullHappyPath() async throws {
        let machine = ConnectionStateMachine()
        try await machine.transition(to: .scanning)
        try await machine.transition(to: .connecting)
        try await machine.transition(to: .connected)
        try await machine.transition(to: .disconnected)
        try await machine.transition(to: .idle)
        let state = await machine.state
        guard case .idle = state else {
            XCTFail("Expected .idle at end of happy path")
            return
        }
    }

    func testInvalidTransitionThrows() async {
        let machine = ConnectionStateMachine()
        do {
            // Cannot jump from idle directly to connected
            try await machine.transition(to: .connected)
            XCTFail("Expected an error to be thrown for invalid transition")
        } catch {
            XCTAssertTrue(error is BluetoothError)
        }
    }
}
