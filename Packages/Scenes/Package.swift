// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Scenes",
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
		.library(
			name: "AddCashbackScene",
			targets: ["AddCashbackScene"]
		),
		.library(
			name: "CardDetailScene",
			targets: ["CardDetailScene"]
		),
		.library(
			name: "CardsListScene",
			targets: ["CardsListScene"]
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
		.target(
			name: "AddCashbackScene",
			dependencies: ["Domain", "DesignSystem", "SelectCategoryScene"]
		),
		.target(
			name: "CardDetailScene",
			dependencies: ["Domain", "DesignSystem"]
		),
		.target(
			name: "CardsListScene",
			dependencies: ["Domain", "DesignSystem", "CommonInputSheet"]
		),
    ]
)
