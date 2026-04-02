import ProjectDescription

let project = Project(
    name: "PotentiaLudi",
    organizationName: "MyAppsMonorepo",
    targets: [
        .target(
            name: "PotentiaLudi",
            destinations: .iOS,
            product: .app,
            bundleId: "com.myappsmonorepo.potentialudi",
            deploymentTargets: .iOS("17.0"),
            sources: ["Sources/PotentiaLudi/**"],
            dependencies: [
                .package(product: "CoreUI"),
                .package(product: "CoreNetworking"),
                .package(product: "CoreAnalytics"),
                .package(product: "Web3Helpers"),
                .package(product: "ARHelpers"),
            ]
        ),
        .target(
            name: "PotentiaLudiTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.myappsmonorepo.potentialuditests",
            sources: ["Tests/PotentiaLudiTests/**"],
            dependencies: [
                .target(name: "PotentiaLudi"),
            ]
        ),
    ],
    packages: [
        .local(path: "../../Packages/CoreUI"),
        .local(path: "../../Packages/CoreNetworking"),
        .local(path: "../../Packages/CoreAnalytics"),
        .local(path: "../../Packages/Web3Helpers"),
        .local(path: "../../Packages/ARHelpers"),
    ]
)
