import Cocoa

extension NSApplication {
	@MainActor
	func relaunch() async throws {
		let configuration = NSWorkspace.OpenConfiguration()
		configuration.createsNewApplicationInstance = true
		try await NSWorkspace.shared.openApplication(at: Bundle.main.bundleURL, configuration: configuration)

		NSApp.terminate(nil)
	}
}
