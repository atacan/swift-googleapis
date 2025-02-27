// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-googleapis",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "GenerativeLanguage",
            targets: ["GenerativeLanguage"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-protobuf.git", from: "1.29.0"),
        .package(url: "https://github.com/grpc/grpc-swift.git", from: "2.0.0"),
        .package(url: "https://github.com/grpc/grpc-swift-protobuf.git", from: "1.0.0"),
        .package(url: "https://github.com/grpc/grpc-swift-nio-transport.git", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "GenerativeLanguage"),
        .testTarget(
            name: "GenerativeLanguageTests",
            dependencies: ["GenerativeLanguage"]
        ),
        .executableTarget(name: "Prepare"),
    ]
)
