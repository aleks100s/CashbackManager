// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CommonScenes",
	platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "CommonInputSheet",
            targets: ["CommonInputSheet"]
		),
		.library(
			name: "SelectCategoryScene",
			targets: ["SelectCategoryScene"]
		),
    ],
	dependencies: [
		.package(name: "Domain", path: "./Domain"),
		.package(name: "DesignSystem", path: "./DesignSystem")
	],
    targets: [
        .target(
			name: "CommonInputSheet",
			dependencies: ["DesignSystem"]
		),
		.target(
			name: "SelectCategoryScene",
			dependencies: ["Domain", "DesignSystem", "CommonInputSheet"]
		),
    ]
)
