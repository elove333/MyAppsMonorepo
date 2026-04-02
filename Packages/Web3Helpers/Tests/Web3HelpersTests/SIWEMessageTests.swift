import XCTest
@testable import Web3Helpers

final class SIWEMessageTests: XCTestCase {

    private func makeMessage() -> SIWEMessage {
        SIWEMessage(
            domain: "example.com",
            address: "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2",
            statement: "Sign in with Ethereum.",
            uri: "https://example.com",
            version: "1",
            chainId: 1,
            nonce: "abc123",
            issuedAt: "2024-01-01T00:00:00Z"
        )
    }

    func testFormattedMessageContainsDomain() {
        let msg = makeMessage()
        XCTAssertTrue(msg.formatted().contains("example.com"))
    }

    func testFormattedMessageContainsAddress() {
        let msg = makeMessage()
        XCTAssertTrue(msg.formatted().contains("0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2"))
    }

    func testFormattedMessageContainsChainId() {
        let msg = makeMessage()
        XCTAssertTrue(msg.formatted().contains("Chain ID: 1"))
    }

    func testFormattedMessageContainsNonce() {
        let msg = makeMessage()
        XCTAssertTrue(msg.formatted().contains("Nonce: abc123"))
    }

    func testFormattedMessageContainsUri() {
        let msg = makeMessage()
        XCTAssertTrue(msg.formatted().contains("URI: https://example.com"))
    }

    func testFormattedMessageContainsVersion() {
        let msg = makeMessage()
        XCTAssertTrue(msg.formatted().contains("Version: 1"))
    }

    func testFormattedMessageContainsIssuedAt() {
        let msg = makeMessage()
        XCTAssertTrue(msg.formatted().contains("Issued At: 2024-01-01T00:00:00Z"))
    }

    func testMessageEquality() {
        let msg1 = makeMessage()
        let msg2 = makeMessage()
        XCTAssertEqual(msg1, msg2)
    }
}
