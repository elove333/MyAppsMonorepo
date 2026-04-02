import SwiftUI

// MARK: - Environment Key

private struct AppThemeKey: EnvironmentKey {
    static let defaultValue: AppTheme = .default
}

extension EnvironmentValues {
    public var appTheme: AppTheme {
        get { self[AppThemeKey.self] }
        set { self[AppThemeKey.self] = newValue }
    }
}

// MARK: - View extension

extension View {
    /// Injects an `AppTheme` into the SwiftUI environment.
    public func appTheme(_ theme: AppTheme) -> some View {
        environment(\.appTheme, theme)
    }
}
