import Foundation

// MARK: - App Lifecycle Events

/// Fired when the app finishes launching.
public struct AppLaunchEvent: AnalyticsEvent {
    public let name = "app_launch"
    public let coldStart: Bool

    public var parameters: [String: any Sendable] {
        ["cold_start": coldStart]
    }

    public init(coldStart: Bool = true) {
        self.coldStart = coldStart
    }
}

/// Fired when the app moves to the background.
public struct AppBackgroundEvent: AnalyticsEvent {
    public let name = "app_background"
    public var parameters: [String: any Sendable] { [:] }

    public init() {}
}

/// Fired when the app returns to the foreground.
public struct AppForegroundEvent: AnalyticsEvent {
    public let name = "app_foreground"
    public var parameters: [String: any Sendable] { [:] }

    public init() {}
}
