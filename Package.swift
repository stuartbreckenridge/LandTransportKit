// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "LandTransportKit",
    platforms: [.iOS(.v17), .macOS(.v15), .tvOS(.v17), .watchOS(.v10)],
    products: [
        .library(
            name: "LandTransportKit",
            targets: ["LandTransportKit"],
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")
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
