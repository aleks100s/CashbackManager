// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Services",
	platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "CategoryService",
            targets: ["CategoryService"]
		),
		.library(
			name: "CashbackService",
			targets: ["CashbackService"]
		)
    ],
	dependencies: [.package(name: "Domain", path: "./Domain")],
    targets: [
		.target(name: "CategoryService", dependencies: ["Domain"]),
		.target(name: "CashbackService", dependencies: ["Domain"]),
    ]
)
