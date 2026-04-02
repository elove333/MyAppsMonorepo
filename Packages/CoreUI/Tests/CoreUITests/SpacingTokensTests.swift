import XCTest
@testable import CoreUI

final class SpacingTokensTests: XCTestCase {

    func testSpacingValuesArePositive() {
        XCTAssertGreaterThan(Spacing.xs, 0)
        XCTAssertGreaterThan(Spacing.sm, 0)
        XCTAssertGreaterThan(Spacing.md, 0)
        XCTAssertGreaterThan(Spacing.lg, 0)
        XCTAssertGreaterThan(Spacing.xl, 0)
    }

    func testSpacingOrderingIsAscending() {
        XCTAssertLessThan(Spacing.xs, Spacing.sm, "xs must be smaller than sm")
        XCTAssertLessThan(Spacing.sm, Spacing.md, "sm must be smaller than md")
        XCTAssertLessThan(Spacing.md, Spacing.lg, "md must be smaller than lg")
        XCTAssertLessThan(Spacing.lg, Spacing.xl, "lg must be smaller than xl")
    }

    func testSpacingSpecificValues() {
        XCTAssertEqual(Spacing.xs, 4)
        XCTAssertEqual(Spacing.sm, 8)
        XCTAssertEqual(Spacing.md, 16)
        XCTAssertEqual(Spacing.lg, 24)
        XCTAssertEqual(Spacing.xl, 40)
    }
}
