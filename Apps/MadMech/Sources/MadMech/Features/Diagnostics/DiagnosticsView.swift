import SwiftUI
import CoreUI

struct DiagnosticsView: View {
    @Environment(\.appTheme) private var theme
    @StateObject private var viewModel = DiagnosticsViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.lg) {
                    connectionSection
                    if viewModel.isConnected {
                        metricsSection
                    } else {
                        scanButton
                    }
                }
                .padding(Spacing.md)
            }
            .background(theme.colors.background.ignoresSafeArea())
            .navigationTitle("OBD2 Diagnostics")
            .overlay {
                if viewModel.isScanning {
                    LoadingIndicator(message: "Scanning for OBD2 device…")
                }
            }
            .alert("Bluetooth Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "Unknown error")
            }
        }
    }

    // MARK: - Sub-views

    private var connectionSection: some View {
        CardView {
            HStack(spacing: Spacing.md) {
                Image(systemName: viewModel.isConnected ? "bluetooth.fill" : "bluetooth")
                    .font(.system(size: 24))
                    .foregroundStyle(viewModel.isConnected ? theme.colors.secondary : theme.colors.onSurface.opacity(0.4))
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(viewModel.isConnected ? "OBD2 Connected" : "No Device")
                        .font(theme.typography.subheadline)
                        .foregroundStyle(theme.colors.onSurface)
                    if let name = viewModel.deviceName {
                        Text(name)
                            .font(theme.typography.caption)
                            .foregroundStyle(theme.colors.onSurface.opacity(0.6))
                    }
                }
                Spacer()
                if viewModel.isConnected {
                    Button("Disconnect") {
                        Task { await viewModel.disconnect() }
                    }
                    .font(theme.typography.caption)
                    .foregroundStyle(theme.colors.error)
                }
            }
        }
    }

    private var metricsSection: some View {
        LazyVGrid(columns: [.init(.flexible()), .init(.flexible())], spacing: Spacing.md) {
            MetricCard(label: "RPM", value: String(format: "%.0f", viewModel.rpm), unit: "rpm")
            MetricCard(label: "Speed", value: String(format: "%.0f", viewModel.speed), unit: "km/h")
            MetricCard(label: "Coolant", value: String(format: "%.0f", viewModel.coolantTemp), unit: "°C")
            MetricCard(label: "Throttle", value: String(format: "%.1f", viewModel.throttle), unit: "%")
        }
    }

    private var scanButton: some View {
        PrimaryButton("Scan for OBD2 Device") {
            Task { await viewModel.startScan() }
        }
    }
}

// MARK: - Metric Card

private struct MetricCard: View {
    @Environment(\.appTheme) private var theme

    let label: String
    let value: String
    let unit: String

    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(label)
                    .font(theme.typography.caption)
                    .foregroundStyle(theme.colors.onSurface.opacity(0.6))
                HStack(alignment: .lastTextBaseline, spacing: 2) {
                    Text(value)
                        .font(.system(.title2, design: .rounded, weight: .bold))
                        .foregroundStyle(theme.colors.primary)
                    Text(unit)
                        .font(theme.typography.caption)
                        .foregroundStyle(theme.colors.onSurface.opacity(0.5))
                }
            }
        }
    }
}
