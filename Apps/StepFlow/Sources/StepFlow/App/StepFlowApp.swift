import SwiftUI
import CoreUI
import CoreAnalytics

@main
struct StepFlowApp: App {
    init() {
        Task {
            await AnalyticsManager.shared.register(adapter: ConsoleAnalyticsAdapter())
            await AnalyticsManager.shared.track(AppLaunchEvent(coldStart: true))
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentRoot()
                .appTheme(.default)
        }
    }
}

private struct ContentRoot: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some View {
        if hasCompletedOnboarding {
            DashboardView()
        } else {
            OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
        }
    }
}
