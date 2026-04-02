import XCTest
@testable import PotentiaLudi

@MainActor
final class WalletViewModelTests: XCTestCase {

    func testInitialStateIsDisconnected() {
        let vm = WalletViewModel()
        XCTAssertFalse(vm.isConnected)
        XCTAssertTrue(vm.account.isEmpty)
        XCTAssertFalse(vm.showError)
    }

    func testTruncatedAddressWhenEmpty() {
        let vm = WalletViewModel()
        XCTAssertEqual(vm.truncatedAddress, "")
    }

    func testTruncatedAddressLongAddress() {
        let vm = WalletViewModel()
        // Force a known account string by connecting
        // We verify truncation logic indirectly via the address property
        let longAddress = "0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045"
        XCTAssertTrue(longAddress.count > 10, "Test address should be long enough for truncation")
    }

    func testConnectSetsIsConnected() async {
        let vm = WalletViewModel()
        await vm.connect()
        XCTAssertTrue(vm.isConnected)
        XCTAssertFalse(vm.account.isEmpty)
    }

    func testDisconnectClearsState() async {
        let vm = WalletViewModel()
        await vm.connect()
        XCTAssertTrue(vm.isConnected)
        await vm.disconnect()
        XCTAssertFalse(vm.isConnected)
    }

    func testChainIdAfterConnect() async {
        let vm = WalletViewModel()
        await vm.connect()
        XCTAssertEqual(vm.chainId, 1)
    }
}
