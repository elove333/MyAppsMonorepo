import SwiftUI
import CoreUI
import CoreAnalytics

@main
struct MadMechApp: App {
    init() {
        Task {
            await AnalyticsManager.shared.register(adapter: ConsoleAnalyticsAdapter())
            await AnalyticsManager.shared.track(AppLaunchEvent(coldStart: true))
        }
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .appTheme(.default)
        }
    }
}

private struct MainTabView: View {
    var body: some View {
        TabView {
            DiagnosticsView()
                .tabItem {
                    Label("Diagnostics", systemImage: "wrench.and.screwdriver.fill")
                }
            ARDiagnosticsView()
                .tabItem {
                    Label("AR View", systemImage: "arkit")
                }
        }
    }
}
