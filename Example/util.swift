import Cocoa

extension NSApplication {
	/// Relaunch the app.
	func relaunch() {
		NSWorkspace.shared.launchApplication(
			withBundleIdentifier: Bundle.main.bundleIdentifier!,
			options: .newInstance,
			additionalEventParamDescriptor: nil,
			launchIdentifier: nil
		)

		NSApp.terminate(nil)
	}
}
