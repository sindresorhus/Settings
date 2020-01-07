// swift-tools-version:5.2
import PackageDescription

let package = Package(
	name: "Preferences",
	platforms: [
		.macOS(.v10_10)
	],
	products: [
		.library(
			name: "Preferences",
			targets: [
				"Preferences"
			]
		)
	],
	targets: [
		.target(
			name: "Preferences"
		)
	]
)
