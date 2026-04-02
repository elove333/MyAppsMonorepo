import SwiftUI
import CoreUI

struct OnboardingView: View {
    @Environment(\.appTheme) private var theme
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentPage = 0

    private let pages: [OnboardingPage] = [
        OnboardingPage(
            icon: "figure.walk",
            title: "Track Your Steps",
            description: "StepFlow automatically counts your daily steps and helps you stay active."
        ),
        OnboardingPage(
            icon: "chart.bar.fill",
            title: "Visualise Progress",
            description: "See your weekly step history at a glance and celebrate milestones."
        ),
        OnboardingPage(
            icon: "target",
            title: "Set Your Goal",
            description: "Choose a personalised daily target and get nudged when you're close."
        ),
    ]

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentPage) {
                ForEach(pages.indices, id: \.self) { index in
                    pageView(pages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))

            VStack(spacing: Spacing.md) {
                if currentPage < pages.count - 1 {
                    PrimaryButton("Next") {
                        withAnimation { currentPage += 1 }
                    }
                    Button("Skip") {
                        hasCompletedOnboarding = true
                    }
                    .font(theme.typography.body)
                    .foregroundStyle(theme.colors.onSurface.opacity(0.6))
                } else {
                    PrimaryButton("Get Started") {
                        hasCompletedOnboarding = true
                    }
                }
            }
            .padding(.horizontal, Spacing.lg)
            .padding(.bottom, Spacing.xl)
        }
        .background(theme.colors.background.ignoresSafeArea())
    }

    private func pageView(_ page: OnboardingPage) -> some View {
        VStack(spacing: Spacing.lg) {
            Spacer()
            Image(systemName: page.icon)
                .font(.system(size: 80))
                .foregroundStyle(theme.colors.primary)
            Text(page.title)
                .font(theme.typography.headline)
                .foregroundStyle(theme.colors.onSurface)
            Text(page.description)
                .font(theme.typography.body)
                .foregroundStyle(theme.colors.onSurface.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.xl)
            Spacer()
        }
    }
}

private struct OnboardingPage {
    let icon: String
    let title: String
    let description: String
}
