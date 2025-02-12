// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "modulegen",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "modulegen", targets: ["modulegen"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.1.0")
    ],
    targets: [
        .executableTarget(
            name: "modulegen",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            resources: [
                .process("Templates")
            ]
        ),
    ]
)
