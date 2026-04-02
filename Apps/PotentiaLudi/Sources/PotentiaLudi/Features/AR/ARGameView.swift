import SwiftUI
import CoreUI
import ARHelpers

struct ARGameView: View {
    @Environment(\.appTheme) private var theme
    @State private var score = 0
    @State private var isGameActive = false

    var body: some View {
        ZStack {
            HolographicOverlay {
                gameHUD
            }

            if !isGameActive {
                startOverlay
            }
        }
        .ignoresSafeArea()
    }

    // MARK: - Sub-views

    private var gameHUD: some View {
        VStack {
            HStack {
                CardView {
                    Text("Score: \(score)")
                        .font(theme.typography.subheadline)
                        .foregroundStyle(theme.colors.onSurface)
                }
                .padding(Spacing.md)
                Spacer()
            }
            Spacer()
        }
    }

    private var startOverlay: some View {
        ZStack {
            Color.black.opacity(0.6).ignoresSafeArea()
            VStack(spacing: Spacing.lg) {
                Text("PotentiaLudi")
                    .font(theme.typography.headline)
                    .foregroundStyle(.white)
                Text("Tap targets in AR to score points.")
                    .font(theme.typography.body)
                    .foregroundStyle(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                PrimaryButton("Start Game") {
                    isGameActive = true
                }
                .padding(.horizontal, Spacing.xl)
            }
        }
    }
}
