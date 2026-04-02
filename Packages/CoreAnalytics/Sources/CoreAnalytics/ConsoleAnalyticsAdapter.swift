import Foundation

/// Prints analytics events to the console — intended for debug builds only.
public struct ConsoleAnalyticsAdapter: AnalyticsAdapter {
    public init() {}

    public func track(_ event: any AnalyticsEvent) async {
        let paramString = event.parameters
            .sorted { $0.key < $1.key }
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: ", ")
        print("[Analytics] \(event.name) { \(paramString) }")
    }
}
