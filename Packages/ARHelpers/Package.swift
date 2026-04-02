// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ARHelpers",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "ARHelpers", targets: ["ARHelpers"]),
    ],
    targets: [
        .target(
            name: "ARHelpers",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]
        ),
        .testTarget(
            name: "ARHelpersTests",
            dependencies: ["ARHelpers"],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]
        ),
    ]
)
