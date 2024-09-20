// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "DTBKit",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "DTBKit",
            targets: ["DTBKit"]
        )
    ],
    targets: [
        .target(
            name: "DTBKit",
            path: "Sources"
        ),
        .testTarget(
            name: "BasicTests",
            dependencies: ["DTBKit"]
        )
    ]
)
