// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CashbackFeature",
	platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "CashbackFeature",
            targets: ["CashbackFeature"]
		),
    ],
	dependencies: [
		.package(name: "Shared", path: "./Shared"),
		.package(name: "Domain", path: "./Domain"),
		.package(name: "DesignSystem", path: "./DesignSystem"),
		.package(name: "Services", path: "./Services"),
		.package(name: "CommonScenes", path: "./CommonScenes"),
	],
    targets: [
        .target(
			name: "CashbackFeature",
			dependencies: [
				"Domain",
				"DesignSystem",
				"Shared",
				"AddCashbackScene",
				"CardDetailScene",
				"CardsListScene",
				.product(name: "CardsService", package: "Services")
			]
		),
		.target(
			name: "AddCashbackScene",
			dependencies: [
				"Domain",
				"DesignSystem",
				.product(name: "SelectCategoryScene", package: "CommonScenes")
			]
		),
		.target(
			name: "CardDetailScene",
			dependencies: ["Shared", "Domain", "DesignSystem"]
		),
		.target(
			name: "CardsListScene",
			dependencies: [
				"Domain",
				"DesignSystem",
				.product(name: "SelectCategoryScene", package: "CommonScenes")
			]
		),
    ]
)
