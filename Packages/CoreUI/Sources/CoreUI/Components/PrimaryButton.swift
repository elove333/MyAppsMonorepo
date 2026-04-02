import SwiftUI

/// A full-width primary action button styled with the current AppTheme.
public struct PrimaryButton: View {
    @Environment(\.appTheme) private var theme
    @Environment(\.isEnabled) private var isEnabled

    private let label: String
    private let action: () -> Void

    public init(_ label: String, action: @escaping () -> Void) {
        self.label = label
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text(label)
                .font(theme.typography.subheadline)
                .foregroundStyle(theme.colors.onPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(theme.colors.primary.opacity(isEnabled ? 1 : 0.5))
                )
        }
        .buttonStyle(.plain)
    }
}
