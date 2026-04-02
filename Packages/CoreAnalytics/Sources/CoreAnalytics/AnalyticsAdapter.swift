import Foundation

/// A backend that receives analytics events (e.g. Firebase, Mixpanel, console).
public protocol AnalyticsAdapter: Sendable {
    func track(_ event: any AnalyticsEvent) async
}
