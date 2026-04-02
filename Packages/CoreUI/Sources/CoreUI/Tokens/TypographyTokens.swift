import SwiftUI

/// Typography scale for the design system.
public struct TypographyTokens {
    public let headline: Font
    public let subheadline: Font
    public let body: Font
    public let caption: Font

    public init(headline: Font, subheadline: Font, body: Font, caption: Font) {
        self.headline = headline
        self.subheadline = subheadline
        self.body = body
        self.caption = caption
    }

    /// Default typography using system fonts with dynamic type support.
    public static let `default` = TypographyTokens(
        headline: .system(.title2, design: .default, weight: .bold),
        subheadline: .system(.headline, design: .default, weight: .semibold),
        body: .system(.body, design: .default, weight: .regular),
        caption: .system(.caption, design: .default, weight: .regular)
    )

    /// Rounded variant for a friendlier, playful feel.
    public static let rounded = TypographyTokens(
        headline: .system(.title2, design: .rounded, weight: .bold),
        subheadline: .system(.headline, design: .rounded, weight: .semibold),
        body: .system(.body, design: .rounded, weight: .regular),
        caption: .system(.caption, design: .rounded, weight: .regular)
    )
}
