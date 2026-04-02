import Foundation

/// Errors thrown by the AR subsystem.
public enum ARError: Error, Sendable, Equatable {
    case sessionFailed(reason: String)
    case poseDetectionFailed
    case unsupportedDevice
}

extension ARError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .sessionFailed(let reason):
            return "AR session failed: \(reason)"
        case .poseDetectionFailed:
            return "Human body pose detection failed."
        case .unsupportedDevice:
            return "This device does not support the required AR capabilities."
        }
    }
}
