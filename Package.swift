// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Flow",
    platforms: [
        .iOS(.v13),
        .macCatalyst(.v13),
        .macOS(.v12),
        .tvOS(.v13),
        .watchOS(.v7),
    ],
    products: [
        .library(name: "Flow", targets: ["Flow"]),
    ],
    targets: [
        .target(
            name: "Flow"),
        .testTarget(
            name: "FlowTests",
            dependencies: ["Flow"]),
    ]
)
