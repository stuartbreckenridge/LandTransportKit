// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "LandTransportKit",
    platforms: [.iOS(.v17), .macOS(.v15), .tvOS(.v17), .watchOS(.v10)],
    products: [
        .library(
            name: "LandTransportKit",
            targets: ["LandTransportKit"]
        ),
    ],
    targets: [
        .target(
            name: "LandTransportKit"
        ),
        .testTarget(
            name: "LandTransportKitTests",
            dependencies: ["LandTransportKit"]
        ),
    ]
)
