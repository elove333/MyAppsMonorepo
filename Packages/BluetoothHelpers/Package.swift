// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "BluetoothHelpers",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "BluetoothHelpers", targets: ["BluetoothHelpers"]),
    ],
    targets: [
        .target(
            name: "BluetoothHelpers",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]
        ),
        .testTarget(
            name: "BluetoothHelpersTests",
            dependencies: ["BluetoothHelpers"],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]
        ),
    ]
)
