// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ReturnResultKit",
    products: [
        .library(
            name: "ReturnResultKit",
            targets: ["ReturnResultKit"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ReturnResultKit",
            dependencies: [])
    ]
)
