// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Services",
	platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
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
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
		.target(name: "CategoryService", dependencies: ["Domain"]),
		.target(name: "CashbackService", dependencies: ["Domain"]),
        .testTarget(
            name: "ServicesTests",
            dependencies: ["CategoryService", "CashbackService"]
		),
    ]
)
