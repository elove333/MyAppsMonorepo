import SwiftUI
import CoreUI

struct DashboardView: View {
    @Environment(\.appTheme) private var theme
    @StateObject private var viewModel = DashboardViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.lg) {
                    stepCountCard
                    weeklyProgressSection
                    goalCard
                }
                .padding(.horizontal, Spacing.md)
                .padding(.top, Spacing.md)
            }
            .background(theme.colors.background.ignoresSafeArea())
            .navigationTitle("Dashboard")
            .overlay {
                if viewModel.isLoading {
                    LoadingIndicator(message: "Fetching steps…")
                }
            }
            .task {
                await viewModel.loadStepData()
            }
        }
    }

    // MARK: - Sub-views

    private var stepCountCard: some View {
        CardView {
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text("Today's Steps")
                    .font(theme.typography.subheadline)
                    .foregroundStyle(theme.colors.onSurface.opacity(0.6))

                Text("\(viewModel.todayStepCount)")
                    .font(.system(size: 56, weight: .bold, design: .rounded))
                    .foregroundStyle(theme.colors.primary)

                ProgressView(value: viewModel.goalProgress)
                    .tint(theme.colors.primary)
            }
        }
    }

    private var weeklyProgressSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("This Week")
                .font(theme.typography.subheadline)
                .foregroundStyle(theme.colors.onSurface)

            HStack(spacing: Spacing.sm) {
                ForEach(viewModel.weeklySteps.indices, id: \.self) { index in
                    DayBarView(
                        day: viewModel.weekDayLabels[index],
                        steps: viewModel.weeklySteps[index],
                        maxSteps: viewModel.weeklySteps.max() ?? 1,
                        color: theme.colors.secondary
                    )
                }
            }
            .frame(height: 100)
        }
    }

    private var goalCard: some View {
        CardView {
            HStack {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("Daily Goal")
                        .font(theme.typography.caption)
                        .foregroundStyle(theme.colors.onSurface.opacity(0.6))
                    Text("\(viewModel.dailyGoal) steps")
                        .font(theme.typography.body)
                        .foregroundStyle(theme.colors.onSurface)
                }
                Spacer()
                Image(systemName: viewModel.goalReached ? "checkmark.circle.fill" : "target")
                    .font(.system(size: 32))
                    .foregroundStyle(viewModel.goalReached ? theme.colors.secondary : theme.colors.primary)
            }
        }
    }
}

// MARK: - Day Bar

private struct DayBarView: View {
    let day: String
    let steps: Int
    let maxSteps: Int
    let color: SwiftUI.Color

    var body: some View {
        VStack(spacing: Spacing.xs) {
            Spacer()
            RoundedRectangle(cornerRadius: 4)
                .fill(color)
                .frame(height: barHeight)
            Text(day)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    private var barHeight: CGFloat {
        guard maxSteps > 0 else { return 4 }
        return max(4, CGFloat(steps) / CGFloat(maxSteps) * 80)
    }
}
