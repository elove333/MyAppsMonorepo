import SwiftUI

/// Brand color palette for the design system.
public struct ColorTokens {
    public let primary: Color
    public let secondary: Color
    public let background: Color
    public let surface: Color
    public let onPrimary: Color
    public let onSurface: Color
    public let error: Color

    public init(
        primary: Color,
        secondary: Color,
        background: Color,
        surface: Color,
        onPrimary: Color,
        onSurface: Color,
        error: Color
    ) {
        self.primary = primary
        self.secondary = secondary
        self.background = background
        self.surface = surface
        self.onPrimary = onPrimary
        self.onSurface = onSurface
        self.error = error
    }

    /// Light-mode default palette.
    public static let light = ColorTokens(
        primary: Color(red: 0.259, green: 0.522, blue: 0.957),    // #4285F4
        secondary: Color(red: 0.180, green: 0.800, blue: 0.443),  // #2ECC71
        background: Color(red: 0.973, green: 0.973, blue: 0.973), // #F8F8F8
        surface: Color.white,
        onPrimary: Color.white,
        onSurface: Color(red: 0.133, green: 0.133, blue: 0.133),  // #222222
        error: Color(red: 0.827, green: 0.184, blue: 0.184)       // #D32F2F
    )

    /// Dark-mode palette.
    public static let dark = ColorTokens(
        primary: Color(red: 0.396, green: 0.620, blue: 0.996),    // #6599FE
        secondary: Color(red: 0.149, green: 0.698, blue: 0.380),  // #26B261
        background: Color(red: 0.071, green: 0.071, blue: 0.071), // #121212
        surface: Color(red: 0.118, green: 0.118, blue: 0.118),    // #1E1E1E
        onPrimary: Color.black,
        onSurface: Color(red: 0.898, green: 0.898, blue: 0.898),  // #E5E5E5
        error: Color(red: 0.937, green: 0.325, blue: 0.314)       // #EF5350
    )
}
