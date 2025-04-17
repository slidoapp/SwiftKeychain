// swift-tools-version: 5.5

import PackageDescription

let package = Package(
    name: "SwiftKeychain",
    platforms: [
        .macOS(.v10_10),
        .iOS(.v8),
        .watchOS(.v2),
        .tvOS(.v9)
    ],
    products: [
        .library(
            name: "SwiftKeychain",
            targets: ["SwiftKeychain"]),
    ],
    targets: [
        .target(
            name: "SwiftKeychain"),
        .testTarget(
            name: "SwiftKeychainTests",
            dependencies: ["SwiftKeychain"]
        ),
    ]
)
