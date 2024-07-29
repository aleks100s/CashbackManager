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
    ],
	dependencies: [
		.package(name: "Shared", path: "./Shared"),
		.package(name: "Domain", path: "./Domain")
	],
    targets: [
		.target(name: "CardsService", dependencies: ["Domain"]),
		.target(
			name: "SearchService",
			dependencies: ["Domain", "Shared"]
		),
    ]
)
