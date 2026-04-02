// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CoreAnalytics",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "CoreAnalytics", targets: ["CoreAnalytics"]),
    ],
    targets: [
        .target(
            name: "CoreAnalytics",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]
        ),
        .testTarget(
            name: "CoreAnalyticsTests",
            dependencies: ["CoreAnalytics"],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]
        ),
    ]
)
