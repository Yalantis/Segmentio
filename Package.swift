// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Segmentio",
    products: [
        .library(name: "Segmentio", targets: ["Segmentio"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Segmentio",
            path: "./Segmentio/Source"
        )
    ]
)
