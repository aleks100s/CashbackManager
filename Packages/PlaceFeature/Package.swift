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
	],
    targets: [
        .target(
			name: "PlaceFeature",
			dependencies: [
				"PlacesListScene",
			]
		),
		.target(
			name: "PlacesListScene",
			dependencies: [
				"Domain",
			]
		)
    ]
)
