import XCTest
@testable import BluetoothHelpers

final class PIDParserTests: XCTestCase {

    func testParseEngineRPM() {
        // Response: [0x41, 0x0C, 0x1A, 0xF8]
        // Expected: ((0x1A * 256) + 0xF8) / 4 = ((26 * 256) + 248) / 4 = 6904 / 4 = 1726
        let response = Data([0x41, 0x0C, 0x1A, 0xF8])
        let rpm = PIDParser.parse(response: response, pid: .engineRPM)
        XCTAssertNotNil(rpm)
        XCTAssertEqual(rpm!, 1726.0, accuracy: 0.01)
    }

    func testParseVehicleSpeed() {
        // Response: [0x41, 0x0D, 0x50]
        // Expected: 0x50 = 80 km/h
        let response = Data([0x41, 0x0D, 0x50])
        let speed = PIDParser.parse(response: response, pid: .vehicleSpeed)
        XCTAssertEqual(speed, 80.0, accuracy: 0.01)
    }

    func testParseCoolantTemp() {
        // Response: [0x41, 0x05, 0x6E]
        // Expected: 0x6E - 40 = 110 - 40 = 70°C
        let response = Data([0x41, 0x05, 0x6E])
        let temp = PIDParser.parse(response: response, pid: .coolantTemp)
        XCTAssertEqual(temp, 70.0, accuracy: 0.01)
    }

    func testParseThrottlePosition() {
        // Response: [0x41, 0x11, 0x80]
        // Expected: (128 * 100) / 255 ≈ 50.196%
        let response = Data([0x41, 0x11, 0x80])
        let throttle = PIDParser.parse(response: response, pid: .throttlePosition)
        XCTAssertNotNil(throttle)
        XCTAssertEqual(throttle!, 50.196, accuracy: 0.01)
    }

    func testTooShortResponseReturnsNil() {
        let response = Data([0x41])
        let result = PIDParser.parse(response: response, pid: .engineRPM)
        XCTAssertNil(result, "Short response should return nil")
    }

    func testWrongModeByteReturnsNil() {
        let response = Data([0x40, 0x0C, 0x1A, 0xF8])
        let result = PIDParser.parse(response: response, pid: .engineRPM)
        XCTAssertNil(result, "Wrong mode byte should return nil")
    }
}
