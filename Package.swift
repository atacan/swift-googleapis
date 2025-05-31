// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-googleapis",
    platforms: [
        .macOS("15.0"),
        .iOS("16.0"),
        .watchOS("9.0"),
        .tvOS("16.0"),
        .visionOS("1.0"),
    ],
    products: [
        .library(name: "GenerativeLanguage", targets: ["GenerativeLanguage"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-protobuf.git", from: "1.29.0"),
    ],
    targets: [
        .target(
            name: "GoogleAPI",
            dependencies: [
                .product(name: "SwiftProtobuf", package: "swift-protobuf"),
            ]
        ),
        .target(
            name: "GoogleRPC",
            dependencies: [
                .product(name: "SwiftProtobuf", package: "swift-protobuf"),
            ]
        ),
        .target(
            name: "GoogleLongRunning",
            dependencies: [
                .product(name: "SwiftProtobuf", package: "swift-protobuf"),
                .target(name: "GoogleRPC"),
            ]
        ),
        .target(
            name: "GenerativeLanguage",
            dependencies: [
                .product(name: "SwiftProtobuf", package: "swift-protobuf"),

                .target(name: "GoogleAPI"),
                .target(name: "GoogleRPC"),
                .target(name: "GoogleLongRunning"),
            ]
        ),
        .testTarget(
            name: "GenerativeLanguageTests",
            dependencies: ["GenerativeLanguage"]
        ),
        .executableTarget(name: "Prepare"),
    ]
)
