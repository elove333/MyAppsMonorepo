// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CoreNetworking",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "CoreNetworking", targets: ["CoreNetworking"]),
    ],
    targets: [
        .target(
            name: "CoreNetworking",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]
        ),
        .testTarget(
            name: "CoreNetworkingTests",
            dependencies: ["CoreNetworking"],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]
        ),
    ]
)
