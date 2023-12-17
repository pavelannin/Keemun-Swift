// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Keemun-Swift",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6),
    ],
    products: [
        .library(name: "Keemun-Swift", targets: ["Keemun-Swift"]),
    ],
    targets: [
        .target(name: "Keemun-Swift"),
        .testTarget(name: "Keemun-SwiftTests", dependencies: ["Keemun-Swift"]),
    ]
)
