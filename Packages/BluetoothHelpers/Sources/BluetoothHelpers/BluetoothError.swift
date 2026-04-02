import Foundation

/// Errors thrown by the Bluetooth / OBD2 subsystem.
public enum BluetoothError: Error, Sendable, Equatable {
    case notSupported
    case notAuthorized
    case connectionFailed(reason: String)
    case pidParseFailed
}

extension BluetoothError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .notSupported:
            return "Bluetooth is not supported on this device."
        case .notAuthorized:
            return "Bluetooth access has not been authorised. Please enable it in Settings."
        case .connectionFailed(let reason):
            return "Connection failed: \(reason)"
        case .pidParseFailed:
            return "Failed to parse the OBD2 PID response."
        }
    }
}
