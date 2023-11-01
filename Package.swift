// swift-tools-version:5.7
import PackageDescription

let package = Package(
	name: "Settings",
    defaultLocalization: "en",
	platforms: [.macOS(.v10_13)],
	products: [
		.library(
			name: "Settings",
			targets: [
				"Settings"
			]
		)
	],
	targets: [
		.target(
			name: "Settings",
            resources: [.process("Resources")]
		)
	]
)
