import SwiftUI
import CoreUI
import Web3Helpers

struct WalletView: View {
    @Environment(\.appTheme) private var theme
    @StateObject private var viewModel = WalletViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.lg) {
                    connectionStatusCard
                    if viewModel.isConnected {
                        accountCard
                        balanceSection
                    } else {
                        connectButton
                    }
                }
                .padding(Spacing.md)
            }
            .background(theme.colors.background.ignoresSafeArea())
            .navigationTitle("Wallet")
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "An unknown error occurred.")
            }
        }
    }

    // MARK: - Sub-views

    private var connectionStatusCard: some View {
        CardView {
            HStack(spacing: Spacing.md) {
                Circle()
                    .fill(viewModel.isConnected ? theme.colors.secondary : theme.colors.error)
                    .frame(width: 12, height: 12)
                Text(viewModel.isConnected ? "Connected" : "Not Connected")
                    .font(theme.typography.body)
                    .foregroundStyle(theme.colors.onSurface)
                Spacer()
            }
        }
    }

    private var accountCard: some View {
        CardView {
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text("Account")
                    .font(theme.typography.caption)
                    .foregroundStyle(theme.colors.onSurface.opacity(0.6))
                Text(viewModel.truncatedAddress)
                    .font(.system(.body, design: .monospaced))
                    .foregroundStyle(theme.colors.onSurface)
                Text("Chain \(viewModel.chainId)")
                    .font(theme.typography.caption)
                    .foregroundStyle(theme.colors.onSurface.opacity(0.5))
            }
        }
    }

    private var balanceSection: some View {
        CardView {
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Balance")
                    .font(theme.typography.caption)
                    .foregroundStyle(theme.colors.onSurface.opacity(0.6))
                Text(viewModel.balance)
                    .font(theme.typography.headline)
                    .foregroundStyle(theme.colors.primary)
            }
        }
    }

    private var connectButton: some View {
        PrimaryButton("Connect Wallet") {
            Task { await viewModel.connect() }
        }
    }
}
