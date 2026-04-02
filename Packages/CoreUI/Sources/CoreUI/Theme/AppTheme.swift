import SwiftUI

/// Combines all design tokens into a single injectable theme.
public struct AppTheme: Sendable {
    public let colors: ColorTokens
    public let typography: TypographyTokens
    public let spacing: Spacing.Type

    public init(colors: ColorTokens, typography: TypographyTokens) {
        self.colors = colors
        self.typography = typography
        self.spacing = Spacing.self
    }

    /// Default light-mode theme.
    public static let `default` = AppTheme(
        colors: .light,
        typography: .default
    )

    /// Dark-mode theme.
    public static let dark = AppTheme(
        colors: .dark,
        typography: .default
    )
}

extension ColorTokens: @unchecked Sendable {}
extension TypographyTokens: @unchecked Sendable {}
