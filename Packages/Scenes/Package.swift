// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Scenes",
	platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "CommonInput",
            targets: ["CommonInput"]
		),
    ],
	dependencies: [
		.package(name: "DesignSystem", path: "./DesignSystem")
	],
    targets: [
        .target(
			name: "CommonInput",
			dependencies: ["DesignSystem"]
		),
        .testTarget(
            name: "ScenesTests",
            dependencies: ["CommonInput"]
		),
    ]
)
