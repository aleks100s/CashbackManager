// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DesignSystem",
	platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "DesignSystem",
            targets: ["DesignSystem"]
		),
    ],
	dependencies: [.package(name: "Domain", path: "./Domain")],
    targets: [
        .target(name: "DesignSystem", dependencies: ["Domain"])
    ]
)
