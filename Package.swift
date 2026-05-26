// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "MRGArchitect",
    platforms: [
        .iOS(.v12),
        .tvOS(.v12)
    ],
    products: [
        .library(
            name: "MRGArchitect",
            targets: ["MRGArchitect"]
        )
    ],
    targets: [
        .target(
            name: "MRGArchitect",
            path: "Sources/MRGArchitect",
            publicHeadersPath: "."
        )
    ]
)
