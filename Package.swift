// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RozetkaPaySDK",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "RozetkaPaySDK",
            targets: ["RozetkaPaySDK"]),
    ],
    targets: [
        .target(
            name: "RozetkaPaySDK",
            path: "Sources",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "RozetkaPaySDKTests",
            dependencies: ["RozetkaPaySDK"]),
    ]
)
