import ProjectDescription

let project = Project(
    name: "StepFlow",
    organizationName: "MyAppsMonorepo",
    targets: [
        .target(
            name: "StepFlow",
            destinations: .iOS,
            product: .app,
            bundleId: "com.myappsmonorepo.stepflow",
            deploymentTargets: .iOS("17.0"),
            sources: ["Sources/StepFlow/**"],
            dependencies: [
                .package(product: "CoreUI"),
                .package(product: "CoreNetworking"),
                .package(product: "CoreAnalytics"),
            ]
        ),
        .target(
            name: "StepFlowTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.myappsmonorepo.stepflowtests",
            sources: ["Tests/StepFlowTests/**"],
            dependencies: [
                .target(name: "StepFlow"),
            ]
        ),
    ],
    packages: [
        .local(path: "../../Packages/CoreUI"),
        .local(path: "../../Packages/CoreNetworking"),
        .local(path: "../../Packages/CoreAnalytics"),
    ]
)
