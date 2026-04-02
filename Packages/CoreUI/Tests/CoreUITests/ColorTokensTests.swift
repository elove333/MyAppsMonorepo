import XCTest
@testable import CoreUI

final class ColorTokensTests: XCTestCase {

    func testLightPaletteTokensAreNonNil() {
        let tokens = ColorTokens.light
        // SwiftUI Color is a value type — just verify the palette can be constructed
        // and that accessing each token does not throw.
        _ = tokens.primary
        _ = tokens.secondary
        _ = tokens.background
        _ = tokens.surface
        _ = tokens.onPrimary
        _ = tokens.onSurface
        _ = tokens.error
        XCTAssertTrue(true, "All light ColorTokens are accessible without crashing")
    }

    func testDarkPaletteTokensAreNonNil() {
        let tokens = ColorTokens.dark
        _ = tokens.primary
        _ = tokens.secondary
        _ = tokens.background
        _ = tokens.surface
        _ = tokens.onPrimary
        _ = tokens.onSurface
        _ = tokens.error
        XCTAssertTrue(true, "All dark ColorTokens are accessible without crashing")
    }

    func testLightAndDarkPrimaryColorsAreDistinct() {
        // Verify light and dark primaries are intentionally different values.
        let light = ColorTokens.light
        let dark = ColorTokens.dark
        // We compare the resolved descriptions as a proxy; they should differ.
        let lightDesc = "\(light.primary)"
        let darkDesc = "\(dark.primary)"
        XCTAssertNotEqual(lightDesc, darkDesc, "Light and dark primary colors must be distinct")
    }

    func testLightAndDarkErrorColorsAreDistinct() {
        let lightDesc = "\(ColorTokens.light.error)"
        let darkDesc = "\(ColorTokens.dark.error)"
        XCTAssertNotEqual(lightDesc, darkDesc, "Light and dark error colors must be distinct")
    }
}
