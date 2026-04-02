import SwiftUI

/// A rounded-rectangle card that wraps arbitrary content and applies a subtle shadow.
public struct CardView<Content: View>: View {
    @Environment(\.appTheme) private var theme

    private let cornerRadius: CGFloat
    private let content: Content

    public init(cornerRadius: CGFloat = 16, @ViewBuilder content: () -> Content) {
        self.cornerRadius = cornerRadius
        self.content = content()
    }

    public var body: some View {
        content
            .padding(Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(theme.colors.surface)
                    .shadow(
                        color: theme.colors.onSurface.opacity(0.08),
                        radius: 8,
                        x: 0,
                        y: 4
                    )
            )
    }
}
