// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "swiftpack-core",
    products: [
        .library(
            name: "PackCore",
            targets: ["PackCore"]
        ),
    ],
    targets: [
        .target(
            name: "PackCore"
        ),
    ]
)
