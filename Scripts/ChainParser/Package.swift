// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ChainParser",
    platforms: [
        .macOS(.v12)
    ],
    dependencies: [
        .package(url: "https://github.com/jpsim/SourceKitten.git", from: "0.34.1"),
    ],
    targets: [
        .executableTarget(
            name: "ChainParser",
            dependencies: [
                .product(name: "SourceKittenFramework", package: "SourceKitten")
            ]),
    ]
)
