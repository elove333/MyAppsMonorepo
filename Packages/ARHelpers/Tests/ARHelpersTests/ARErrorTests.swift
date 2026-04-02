import XCTest
@testable import ARHelpers

final class ARErrorTests: XCTestCase {

    func testSessionFailedDescriptionIncludesReason() {
        let reason = "Camera access denied"
        let error = ARError.sessionFailed(reason: reason)
        XCTAssertTrue(
            error.errorDescription?.contains(reason) == true,
            "errorDescription should include the failure reason"
        )
    }

    func testPoseDetectionFailedDescription() {
        let error = ARError.poseDetectionFailed
        XCTAssertEqual(
            error.errorDescription,
            "Human body pose detection failed."
        )
    }

    func testUnsupportedDeviceDescription() {
        let error = ARError.unsupportedDevice
        XCTAssertFalse(
            error.errorDescription?.isEmpty ?? true,
            "errorDescription should not be empty"
        )
    }

    func testEqualityForSessionFailed() {
        let e1 = ARError.sessionFailed(reason: "test")
        let e2 = ARError.sessionFailed(reason: "test")
        XCTAssertEqual(e1, e2)
    }

    func testInequalityForDifferentReasons() {
        let e1 = ARError.sessionFailed(reason: "reason A")
        let e2 = ARError.sessionFailed(reason: "reason B")
        XCTAssertNotEqual(e1, e2)
    }
}
