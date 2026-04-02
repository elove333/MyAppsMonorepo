import SwiftUI
import CoreUI
import CoreAnalytics

@main
struct PotentiaLudiApp: App {
    init() {
        Task {
            await AnalyticsManager.shared.register(adapter: ConsoleAnalyticsAdapter())
            await AnalyticsManager.shared.track(AppLaunchEvent(coldStart: true))
        }
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .appTheme(.dark)
        }
    }
}

private struct MainTabView: View {
    var body: some View {
        TabView {
            WalletView()
                .tabItem {
                    Label("Wallet", systemImage: "wallet.pass.fill")
                }
            ARGameView()
                .tabItem {
                    Label("Play", systemImage: "arkit")
                }
        }
    }
}
