import XCTest
@testable import CoreNetworking

final class RetryPolicyTests: XCTestCase {

    func testConstantBackoffAlwaysReturnsTheSameDelay() {
        let policy = RetryPolicy(maxAttempts: 5, backoff: .constant(2.0))
        for attempt in 0..<5 {
            XCTAssertEqual(
                policy.backoff.delay(forAttempt: attempt),
                2.0,
                accuracy: 0.001,
                "Constant backoff should always return 2.0 seconds"
            )
        }
    }

    func testExponentialBackoffDoublesEachAttempt() {
        let backoff = BackoffStrategy.exponential(base: 1.0, maxDelay: 60.0)
        XCTAssertEqual(backoff.delay(forAttempt: 0), 1.0,  accuracy: 0.001)
        XCTAssertEqual(backoff.delay(forAttempt: 1), 2.0,  accuracy: 0.001)
        XCTAssertEqual(backoff.delay(forAttempt: 2), 4.0,  accuracy: 0.001)
        XCTAssertEqual(backoff.delay(forAttempt: 3), 8.0,  accuracy: 0.001)
        XCTAssertEqual(backoff.delay(forAttempt: 4), 16.0, accuracy: 0.001)
    }

    func testExponentialBackoffRespectsMaxDelay() {
        let backoff = BackoffStrategy.exponential(base: 1.0, maxDelay: 10.0)
        XCTAssertEqual(backoff.delay(forAttempt: 10), 10.0, accuracy: 0.001,
                       "Delay should be capped at maxDelay")
    }

    func testDefaultPolicyHasThreeAttempts() {
        XCTAssertEqual(RetryPolicy.default.maxAttempts, 3)
    }

    func testNonePolicyHasZeroAttempts() {
        XCTAssertEqual(RetryPolicy.none.maxAttempts, 0)
    }
}
