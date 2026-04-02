import XCTest
@testable import Web3Helpers

final class Web3ErrorTests: XCTestCase {

    func testWalletNotConnectedDescription() {
        let error = Web3Error.walletNotConnected
        XCTAssertEqual(error.errorDescription, "No wallet is currently connected.")
    }

    func testAuthFailedDescription() {
        let error = Web3Error.authFailed
        XCTAssertEqual(error.errorDescription, "Sign-In With Ethereum authentication failed.")
    }

    func testRPCErrorDescriptionIncludesMessage() {
        let error = Web3Error.rpcError("execution reverted")
        XCTAssertTrue(error.errorDescription?.contains("execution reverted") == true)
    }

    func testInsufficientFundsDescription() {
        let error = Web3Error.insufficientFunds
        XCTAssertFalse(error.errorDescription?.isEmpty ?? true)
    }

    func testQuoteUnavailableDescription() {
        let error = Web3Error.quoteUnavailable
        XCTAssertFalse(error.errorDescription?.isEmpty ?? true)
    }

    func testEqualityForRPCErrors() {
        XCTAssertEqual(Web3Error.rpcError("out of gas"), Web3Error.rpcError("out of gas"))
        XCTAssertNotEqual(Web3Error.rpcError("out of gas"), Web3Error.rpcError("revert"))
    }
}
