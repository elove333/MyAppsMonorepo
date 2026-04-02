import XCTest
@testable import CoreNetworking

final class NetworkErrorTests: XCTestCase {

    func testInvalidURLDescription() {
        let error = NetworkError.invalidURL
        XCTAssertEqual(error.errorDescription, "The URL provided was invalid.")
    }

    func testHTTPErrorDescriptionIncludesStatusCode() {
        let error = NetworkError.httpError(statusCode: 404)
        XCTAssertTrue(
            error.errorDescription?.contains("404") == true,
            "Error description should mention the status code"
        )
    }

    func testDecodingErrorDescription() {
        let error = NetworkError.decodingError
        XCTAssertEqual(error.errorDescription, "Failed to decode the server response.")
    }

    func testTimeoutDescription() {
        let error = NetworkError.timeout
        XCTAssertEqual(error.errorDescription, "The request timed out.")
    }

    func testCancelledDescription() {
        let error = NetworkError.cancelled
        XCTAssertEqual(error.errorDescription, "The request was cancelled.")
    }

    func testEqualityForHTTPErrors() {
        XCTAssertEqual(NetworkError.httpError(statusCode: 500), NetworkError.httpError(statusCode: 500))
        XCTAssertNotEqual(NetworkError.httpError(statusCode: 500), NetworkError.httpError(statusCode: 503))
    }
}
