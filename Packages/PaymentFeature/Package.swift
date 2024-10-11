// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PaymentFeature",
	platforms: [.iOS(.v17)],
	products: [
		.library(
			name: "PaymentFeature",
			targets: ["PaymentFeature"]
		),
	],
	dependencies: [
		.package(name: "Domain", path: "./Domain"),
	],
	targets: [
		.target(
			name: "PaymentFeature",
			dependencies: [
				"Domain"
			]
		)
	]
)
