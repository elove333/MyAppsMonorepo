import Foundation

/// A typed analytics event that can be dispatched through `AnalyticsManager`.
public protocol AnalyticsEvent: Sendable {
    /// Human-readable event name (e.g. `"app_launch"`).
    var name: String { get }
    /// Free-form key-value metadata attached to the event.
    var parameters: [String: any Sendable] { get }
}
