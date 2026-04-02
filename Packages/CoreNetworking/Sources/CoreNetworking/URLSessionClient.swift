import Foundation

/// URLSession-backed implementation of `APIClient`.
public actor URLSessionClient: APIClient {
    private let session: URLSession
    private let decoder: JSONDecoder

    public init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    public func send<T: Decodable & Sendable>(_ request: APIRequest) async throws -> T {
        let urlRequest = request.urlRequest()

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: urlRequest)
        } catch let error as URLError where error.code == .timedOut {
            throw NetworkError.timeout
        } catch let error as URLError where error.code == .cancelled {
            throw NetworkError.cancelled
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.httpError(statusCode: -1)
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
}
