// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Afluent",
    platforms: [.iOS(.v15), .macOS(.v13), .macCatalyst(.v15), .tvOS(.v16), .watchOS(.v9)],
    products: [
        .library(
            name: "Afluent",
            targets: ["Afluent"]),
    ],
    dependencies: [
        .package(url: "https://github.com/mattgallagher/CwlPreconditionTesting.git", from: "2.0.0"),
        .package(url: "https://github.com/apple/swift-async-algorithms", from: "0.1.0"),
        .package(url: "https://github.com/apple/swift-atomics.git", from: "1.2.0"),
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
    ],
    targets: [
        .target(name: "Afluent",
                dependencies: [
                    .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
                    .product(name: "Atomics", package: "swift-atomics"),
                ]),
        .testTarget(
            name: "AfluentTests",
            dependencies: ["Afluent", "CwlPreconditionTesting"]),
    ]
)
