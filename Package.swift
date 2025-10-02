// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "Keemun",
    platforms: [
        .iOS(.v13),
        .macOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
    ],
    products: [
        .library(name: "Keemun", targets: ["Keemun"]),
    ],
    dependencies: [
        .package(url: "https://github.com/groue/CombineExpectations.git", from: "0.10.0"),
    ],
    targets: [
        .target(name: "Keemun"),
        .testTarget(name: "KeemunTests", dependencies: ["Keemun", "CombineExpectations"]),
    ]
)
