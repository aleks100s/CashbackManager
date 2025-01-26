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
	dependencies: [
		.package(name: "Domain", path: "./Domain"),
		.package(url: "https://github.com/yandexmobile/yandex-ads-sdk-ios.git", exact: .init(7, 9, 0))
	],
    targets: [
		.target(name: "DesignSystem", dependencies: ["Domain", .product(name: "YandexMobileAds", package: "yandex-ads-sdk-ios")])
    ]
)
