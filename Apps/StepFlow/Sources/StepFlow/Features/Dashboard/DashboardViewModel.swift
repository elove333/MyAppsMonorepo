import Foundation
import Combine
import CoreAnalytics

@MainActor
final class DashboardViewModel: ObservableObject {

    // MARK: - Published state

    @Published private(set) var todayStepCount: Int = 0
    @Published private(set) var weeklySteps: [Int] = Array(repeating: 0, count: 7)
    @Published private(set) var dailyGoal: Int = 10_000
    @Published private(set) var isLoading: Bool = false

    // MARK: - Computed

    var goalProgress: Double {
        guard dailyGoal > 0 else { return 0 }
        return min(Double(todayStepCount) / Double(dailyGoal), 1.0)
    }

    var goalReached: Bool { todayStepCount >= dailyGoal }

    var weekDayLabels: [String] {
        let symbols = Calendar.current.shortWeekdaySymbols
        let today = Calendar.current.component(.weekday, from: Date()) - 1
        return (0..<7).map { offset in
            symbols[(today - 6 + offset + 7) % 7]
        }
    }

    // MARK: - Actions

    func loadStepData() async {
        isLoading = true
        defer { isLoading = false }

        // Simulate fetching HealthKit / server data
        try? await Task.sleep(for: .milliseconds(600))

        todayStepCount = Int.random(in: 3_000...12_000)
        weeklySteps = (0..<7).map { _ in Int.random(in: 2_000...14_000) }

        await AnalyticsManager.shared.track(DashboardViewedEvent(stepCount: todayStepCount))
    }

    func updateGoal(_ newGoal: Int) {
        dailyGoal = newGoal
    }
}

// MARK: - Analytics event

private struct DashboardViewedEvent: AnalyticsEvent {
    let name = "dashboard_viewed"
    let stepCount: Int
    var parameters: [String: any Sendable] { ["step_count": stepCount] }
}
