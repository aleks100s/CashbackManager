// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Services",
	platforms: [.iOS(.v17)],
    products: [
		.library(
			name: "CardsService",
			targets: ["CardsService"]
		),
		.library(
			name: "SearchService",
			targets: ["SearchService"]
		),
		.library(
			name: "PlaceService",
			targets: ["PlaceService"]
		),
		.library(
			name: "CategoryService",
			targets: ["CategoryService"]
		),
		.library(
			name: "TextDetectionService",
			targets: ["TextDetectionService"]
		),
		.library(
			name: "IncomeService",
			targets: ["IncomeService"]
		),
		.library(
			name: "NotificationService",
			targets: ["NotificationService"]
		),
		.library(
			name: "UserDataService",
			targets: ["UserDataService"]
		)
    ],
	dependencies: [
		.package(name: "Shared", path: "./Shared"),
		.package(name: "Domain", path: "./Domain")
	],
    targets: [
		.target(name: "CardsService", dependencies: ["Domain", "Shared"]),
		.target(
			name: "SearchService",
			dependencies: ["Domain", "Shared"]
		),
		.target(name: "PlaceService", dependencies: ["Domain"]),
		.target(name: "CategoryService", dependencies: ["Domain"]),
		.target(name: "TextDetectionService", dependencies: ["Domain"]),
		.target(name: "IncomeService", dependencies: ["Domain"]),
		.target(name: "NotificationService", dependencies: ["Shared"]),
		.target(
			name: "UserDataService",
			dependencies: [
				"SearchService"
			]
		)
    ]
)
