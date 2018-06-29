// swift-tools-version:4.1
import PackageDescription

let package = Package(
	name: "Preferences",
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
