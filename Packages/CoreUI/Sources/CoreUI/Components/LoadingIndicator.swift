import SwiftUI

/// A full-screen overlay showing an activity spinner and an optional message.
public struct LoadingIndicator: View {
    @Environment(\.appTheme) private var theme

    private let message: String?

    public init(message: String? = nil) {
        self.message = message
    }

    public var body: some View {
        ZStack {
            theme.colors.background
                .opacity(0.75)
                .ignoresSafeArea()

            VStack(spacing: Spacing.md) {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(theme.colors.primary)
                    .scaleEffect(1.5)

                if let message {
                    Text(message)
                        .font(theme.typography.body)
                        .foregroundStyle(theme.colors.onSurface)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(Spacing.xl)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(theme.colors.surface)
                    .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 6)
            )
        }
    }
}
