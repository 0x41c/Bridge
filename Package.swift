// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "Bridge",
    products: [
        .library(
            name: "Bridge",
            targets: ["Bridge"])
    ],
    targets: [
        .target(
            name: "Bridge",
            dependencies: [
                .target(name: "BSRuntime")
            ]
        ),
        .target(name: "BSRuntime"),
        .testTarget(
            name: "BridgeTests",
            dependencies: ["Bridge"]),
        .testTarget(
            name: "BSRuntimeTests",
            dependencies: ["BSRuntime"]
        )
    ],
    swiftLanguageVersions: [.v5]
)
