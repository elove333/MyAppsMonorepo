import XCTest
@testable import MadMech

@MainActor
final class DiagnosticsViewModelTests: XCTestCase {

    func testInitialStateIsIdle() {
        let vm = DiagnosticsViewModel()
        XCTAssertFalse(vm.isScanning)
        XCTAssertFalse(vm.isConnected)
        XCTAssertNil(vm.deviceName)
    }

    func testInitialMetricsAreZero() {
        let vm = DiagnosticsViewModel()
        XCTAssertEqual(vm.rpm, 0)
        XCTAssertEqual(vm.speed, 0)
        XCTAssertEqual(vm.coolantTemp, 0)
        XCTAssertEqual(vm.throttle, 0)
    }

    func testStartScanSetsConnectedAfterDelay() async {
        let vm = DiagnosticsViewModel()
        await vm.startScan()
        XCTAssertTrue(vm.isConnected)
        XCTAssertNotNil(vm.deviceName)
        XCTAssertFalse(vm.isScanning)
    }

    func testDisconnectClearsState() async {
        let vm = DiagnosticsViewModel()
        await vm.startScan()
        XCTAssertTrue(vm.isConnected)
        await vm.disconnect()
        XCTAssertFalse(vm.isConnected)
        XCTAssertNil(vm.deviceName)
    }

    func testDisconnectResetsMetrics() async {
        let vm = DiagnosticsViewModel()
        await vm.startScan()
        await vm.disconnect()
        XCTAssertEqual(vm.rpm, 0)
        XCTAssertEqual(vm.speed, 0)
    }

    func testShowErrorDefaultsFalse() {
        let vm = DiagnosticsViewModel()
        XCTAssertFalse(vm.showError)
        XCTAssertNil(vm.errorMessage)
    }
}
