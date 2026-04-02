import Foundation

/// Strategy for calculating delay between retry attempts.
public enum BackoffStrategy: Sendable {
    /// Always wait the same duration.
    case constant(TimeInterval)
    /// Wait `base * 2^attempt` seconds; capped at `maxDelay`.
    case exponential(base: TimeInterval, maxDelay: TimeInterval)

    /// Returns the delay in seconds for a given attempt index (0-based).
    public func delay(forAttempt attempt: Int) -> TimeInterval {
        switch self {
        case .constant(let interval):
            return interval
        case .exponential(let base, let maxDelay):
            let calculated = base * pow(2.0, Double(attempt))
            return min(calculated, maxDelay)
        }
    }
}

/// Configures how a failed request should be retried.
public struct RetryPolicy: Sendable {
    public let maxAttempts: Int
    public let backoff: BackoffStrategy

    public init(maxAttempts: Int, backoff: BackoffStrategy) {
        self.maxAttempts = maxAttempts
        self.backoff = backoff
    }

    /// No retries.
    public static let none = RetryPolicy(maxAttempts: 0, backoff: .constant(0))

    /// Three retries with exponential back-off starting at 1 second, capped at 30 seconds.
    public static let `default` = RetryPolicy(
        maxAttempts: 3,
        backoff: .exponential(base: 1.0, maxDelay: 30.0)
    )
}
