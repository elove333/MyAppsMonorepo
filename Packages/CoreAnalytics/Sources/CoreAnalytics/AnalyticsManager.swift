import Foundation

/// Central hub that fans-out analytics events to all registered adapters.
public actor AnalyticsManager {

    /// Process-wide shared instance.
    public static let shared = AnalyticsManager()

    private var adapters: [any AnalyticsAdapter] = []

    public init() {}

    /// Registers a new adapter. Duplicate adapters are allowed (useful for testing).
    public func register(adapter: any AnalyticsAdapter) {
        adapters.append(adapter)
    }

    /// Removes all registered adapters (useful in tests).
    public func removeAllAdapters() {
        adapters.removeAll()
    }

    /// Dispatches `event` to every registered adapter concurrently.
    public func track(_ event: any AnalyticsEvent) async {
        await withTaskGroup(of: Void.self) { group in
            for adapter in adapters {
                group.addTask {
                    await adapter.track(event)
                }
            }
        }
    }
}
