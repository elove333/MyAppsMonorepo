// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Web3Helpers",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "Web3Helpers", targets: ["Web3Helpers"]),
    ],
    targets: [
        .target(
            name: "Web3Helpers",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]
        ),
        .testTarget(
            name: "Web3HelpersTests",
            dependencies: ["Web3Helpers"],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]
        ),
    ]
)
