import Foundation

/// Represents an HTTP method for an API request.
public enum HTTPMethod: String, Sendable {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case patch  = "PATCH"
    case delete = "DELETE"
}

/// A value-type description of a single HTTP request.
public struct APIRequest: Sendable {
    public let url: URL
    public let method: HTTPMethod
    public let headers: [String: String]
    public let body: Data?

    public init(
        url: URL,
        method: HTTPMethod = .get,
        headers: [String: String] = [:],
        body: Data? = nil
    ) {
        self.url = url
        self.method = method
        self.headers = headers
        self.body = body
    }

    /// Converts this value into a `URLRequest` ready for transmission.
    public func urlRequest() -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        return request
    }
}
