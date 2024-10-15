// swift-tools-version: 5.9
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
		.package(name: "DesignSystem", path: "./DesignSystem"),
		.package(name: "Services", path: "./Services"),
		.package(name: "Shared", path: "./Shared"),
	],
	targets: [
		.target(
			name: "PaymentFeature",
			dependencies: [
				"Domain",
				"DesignSystem",
				"Shared",
				.product(name: "IncomeService", package: "Services")
			]
		)
	]
)
