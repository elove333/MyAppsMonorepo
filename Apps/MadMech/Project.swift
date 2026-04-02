import ProjectDescription

let project = Project(
    name: "MadMech",
    organizationName: "MyAppsMonorepo",
    targets: [
        .target(
            name: "MadMech",
            destinations: .iOS,
            product: .app,
            bundleId: "com.myappsmonorepo.madmech",
            deploymentTargets: .iOS("17.0"),
            sources: ["Sources/MadMech/**"],
            dependencies: [
                .package(product: "CoreUI"),
                .package(product: "CoreNetworking"),
                .package(product: "CoreAnalytics"),
                .package(product: "BluetoothHelpers"),
                .package(product: "ARHelpers"),
            ]
        ),
        .target(
            name: "MadMechTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.myappsmonorepo.madmechtests",
            sources: ["Tests/MadMechTests/**"],
            dependencies: [
                .target(name: "MadMech"),
            ]
        ),
    ],
    packages: [
        .local(path: "../../Packages/CoreUI"),
        .local(path: "../../Packages/CoreNetworking"),
        .local(path: "../../Packages/CoreAnalytics"),
        .local(path: "../../Packages/BluetoothHelpers"),
        .local(path: "../../Packages/ARHelpers"),
    ]
)
