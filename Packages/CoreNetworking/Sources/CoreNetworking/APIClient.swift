import Foundation

/// Abstraction for executing typed HTTP requests.
public protocol APIClient: Sendable {
    func send<T: Decodable & Sendable>(_ request: APIRequest) async throws -> T
}
