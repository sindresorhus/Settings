// swift-tools-version:5.1
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
		),
		.library(
			name: "PreferencesSwiftUI",
			targets: [
				"PreferencesSwiftUI"
			]
		)
	],
	targets: [
		.target(
			name: "Preferences"
		),
		.target(
			name: "PreferencesSwiftUI",
			dependencies: ["Preferences"]
		)
	]
)
