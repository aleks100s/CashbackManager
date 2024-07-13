// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Data",
	platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "PersistanceManager",
            targets: ["PersistanceManager"]),
    ],
	dependencies: [
		.package(name: "Domain", path: "./Domain"),
		.package(name: "Services", path: "./Services")
	],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "PersistanceManager",
			dependencies: [
				"Domain",
				.product(name: "Persistance", package: "Services")
			]
		)
    ]
)
