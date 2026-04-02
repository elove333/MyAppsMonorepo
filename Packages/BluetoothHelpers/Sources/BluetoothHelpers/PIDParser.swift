import Foundation

// MARK: - OBD2 PID Definitions

/// Supported OBD2 Parameter IDs (PIDs).
public enum OBD2PID: UInt8, Sendable {
    case engineRPM       = 0x0C
    case vehicleSpeed    = 0x0D
    case coolantTemp     = 0x05
    case throttlePosition = 0x11
}

// MARK: - PID Parser

/// Stateless parser that converts raw OBD2 response bytes into engineering values.
public struct PIDParser: Sendable {

    public init() {}

    /// Parses a raw OBD2 response for the given `pid` and returns the decoded value.
    ///
    /// - Parameters:
    ///   - response: Raw bytes returned by the OBD2 adapter (mode 41 response).
    ///   - pid: The PID that was queried.
    /// - Returns: Decoded value, or `nil` if the response is too short or malformed.
    public static func parse(response: Data, pid: OBD2PID) -> Double? {
        // Standard OBD2 responses: [0x41, PID, A, B, ...]
        // Minimum length is 3 bytes (header + PID + at least byte A).
        guard response.count >= 3 else { return nil }

        // Validate mode and PID echo bytes.
        guard response[0] == 0x41, response[1] == pid.rawValue else { return nil }

        let a = Double(response[2])
        let b = response.count > 3 ? Double(response[3]) : 0.0

        switch pid {
        case .engineRPM:
            // Formula: ((A * 256) + B) / 4
            return ((a * 256) + b) / 4.0

        case .vehicleSpeed:
            // Formula: A  (km/h)
            return a

        case .coolantTemp:
            // Formula: A - 40  (°C)
            return a - 40.0

        case .throttlePosition:
            // Formula: (A * 100) / 255  (%)
            return (a * 100.0) / 255.0
        }
    }
}
