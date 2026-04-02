import Foundation

// MARK: - ConnectionState

/// The possible states of a Bluetooth OBD2 connection.
public enum ConnectionState: Sendable {
    case idle
    case scanning
    case connecting
    case connected
    case disconnected
    case error(any Error & Sendable)
}

// MARK: - ConnectionStateMachine

/// Validates and applies `ConnectionState` transitions.
public actor ConnectionStateMachine {

    private(set) public var state: ConnectionState = .idle

    public init() {}

    /// Attempts to transition to `newState`.
    /// - Throws: `BluetoothError.connectionFailed` if the transition is invalid.
    public func transition(to newState: ConnectionState) throws {
        guard isValidTransition(from: state, to: newState) else {
            throw BluetoothError.connectionFailed(
                reason: "Invalid transition from \(state) to \(newState)"
            )
        }
        state = newState
    }

    // MARK: - Helpers

    private func isValidTransition(from current: ConnectionState, to next: ConnectionState) -> Bool {
        switch (current, next) {
        case (.idle, .scanning):           return true
        case (.scanning, .connecting):     return true
        case (.scanning, .idle):           return true
        case (.connecting, .connected):    return true
        case (.connecting, .error):        return true
        case (.connected, .disconnected):  return true
        case (.disconnected, .idle):       return true
        case (.disconnected, .scanning):   return true
        case (.error, .idle):              return true
        default:                           return false
        }
    }
}
