import Foundation

/// Errors that can be thrown by `URLSessionClient` and related networking code.
public enum NetworkError: Error, Sendable, Equatable {
    case invalidURL
    case httpError(statusCode: Int)
    case decodingError
    case timeout
    case cancelled
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL provided was invalid."
        case .httpError(let statusCode):
            return "The server returned an HTTP error with status code \(statusCode)."
        case .decodingError:
            return "Failed to decode the server response."
        case .timeout:
            return "The request timed out."
        case .cancelled:
            return "The request was cancelled."
        }
    }
}
