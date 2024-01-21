// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "KeemunSwift",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6),
    ],
    products: [
        .library(name: "KeemunSwift", targets: ["KeemunSwift"]),
    ],
    dependencies: [
        .package(url: "https://github.com/groue/CombineExpectations.git", from: "0.10.0"),
    ],
    targets: [
        .target(name: "KeemunSwift"),
        .testTarget(name: "KeemunSwiftTests", dependencies: ["KeemunSwift", "CombineExpectations"]),
    ]
)
