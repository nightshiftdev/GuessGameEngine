// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GuessGameEngine",
    platforms: [
        .macOS(.v10_13),
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "GuessGameEngine",
            targets: ["GuessGameEngine"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "GuessGameEngine",
            dependencies: []),
        .testTarget(
            name: "GuessGameEngineTests",
            dependencies: ["GuessGameEngine"]),
    ]
)
