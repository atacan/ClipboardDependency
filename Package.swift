// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ClipboardDependency",
    platforms: [
        .macOS(.v13),
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ClipboardDependency",
            targets: ["ClipboardDependency"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ClipboardDependency", dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
            ]),
        .testTarget(
            name: "ClipboardDependencyTests",
            dependencies: ["ClipboardDependency"]),
    ]
)
