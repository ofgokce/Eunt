// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Eunt",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "Eunt",
            targets: ["Eunt"]),
    ],
    targets: [
        .target(
            name: "Eunt",
            dependencies: []),
        .testTarget(
            name: "EuntTests",
            dependencies: ["Eunt"]),
    ]
)
