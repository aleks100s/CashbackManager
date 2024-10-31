// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PlaceFeature",
	platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "PlaceFeature",
            targets: ["PlaceFeature"]
		),
    ],
	dependencies: [
		.package(name: "Domain", path: "./Domain"),
		.package(name: "DesignSystem", path: "./DesignSystem"),
		.package(name: "CommonScenes", path: "./CommonScenes"),
		.package(name: "Services", path: "./Services"),
		.package(name: "Shared", path: "./Shared"),
	],
    targets: [
        .target(
			name: "PlaceFeature",
			dependencies: [
				"PlacesListScene",
				"PlaceDetailScene",
				"AddPlaceScene"
			]
		),
		.target(
			name: "PlacesListScene",
			dependencies: [
				"Domain",
				"DesignSystem",
				.product(name: "SearchService", package: "Services"),
				.product(name: "PlaceService", package: "Services")
			]
		),
		.target(
			name: "PlaceDetailScene",
			dependencies: [
				"Domain",
				"DesignSystem",
				"Shared",
				.product(name: "CardsService", package: "Services"),
			]
		),
		.target(
			name: "AddPlaceScene",
			dependencies: [
				"Domain",
				"DesignSystem",
				.product(name: "SelectCategoryScene", package: "CommonScenes"),
				.product(name: "SearchService", package: "Services"),
				.product(name: "PlaceService", package: "Services")
			]
		)
    ]
)
