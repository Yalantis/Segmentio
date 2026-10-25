// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Segmentio",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(name: "Segmentio", targets: ["Segmentio"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Segmentio",
            path: "./Segmentio/Source",
            resources: [
                .process("Badge/Views/BadgeWithCounterViewBigSized.xib"),
                .process("Badge/Views/BadgeWithCounterViewStandardSized.xib")
            ]
        )
    ]
)
