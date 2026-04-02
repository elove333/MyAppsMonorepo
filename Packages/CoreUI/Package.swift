// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CoreUI",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "CoreUI", targets: ["CoreUI"]),
    ],
    targets: [
        .target(
            name: "CoreUI",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]
        ),
        .testTarget(
            name: "CoreUITests",
            dependencies: ["CoreUI"],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]
        ),
    ]
)
