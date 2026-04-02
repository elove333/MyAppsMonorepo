import SwiftUI
import CoreUI
import ARHelpers

struct ARDiagnosticsView: View {
    @Environment(\.appTheme) private var theme
    @State private var showMetrics = true

    var body: some View {
        ZStack {
            HolographicOverlay {
                if showMetrics {
                    arOverlayHUD
                }
            }

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        withAnimation { showMetrics.toggle() }
                    } label: {
                        Image(systemName: showMetrics ? "eye.slash" : "eye")
                            .font(.system(size: 20))
                            .foregroundStyle(.white)
                            .padding(Spacing.md)
                            .background(Circle().fill(.black.opacity(0.5)))
                    }
                    .padding(Spacing.md)
                }
            }
        }
        .ignoresSafeArea()
    }

    private var arOverlayHUD: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    arMetricBadge(label: "RPM", value: "—")
                    arMetricBadge(label: "SPEED", value: "—")
                    arMetricBadge(label: "TEMP", value: "—")
                }
                .padding(Spacing.md)
                Spacer()
            }
            Spacer()
        }
    }

    private func arMetricBadge(label: String, value: String) -> some View {
        HStack(spacing: Spacing.xs) {
            Text(label)
                .font(.system(size: 10, weight: .semibold, design: .monospaced))
                .foregroundStyle(.white.opacity(0.7))
            Text(value)
                .font(.system(size: 14, weight: .bold, design: .monospaced))
                .foregroundStyle(.white)
        }
        .padding(.horizontal, Spacing.sm)
        .padding(.vertical, Spacing.xs)
        .background(Capsule().fill(.black.opacity(0.6)))
    }
}
