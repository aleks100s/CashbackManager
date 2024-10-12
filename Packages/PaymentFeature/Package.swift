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
		.package(name: "DesignSystem", path: "./DesignSystem"),
		.package(name: "Services", path: "./Services"),
	],
	targets: [
		.target(
			name: "PaymentFeature",
			dependencies: [
				"Domain",
				"DesignSystem",
				.product(name: "IncomeService", package: "Services")
			]
		)
	]
)
