import Cocoa
import Preferences

@NSApplicationMain
final class AppDelegate: NSObject, NSApplicationDelegate {
	@IBOutlet private weak var window: NSWindow!

	let preferencesWindowController = PreferencesWindowController(
		viewControllers: [
			GeneralPreferenceViewController(),
			AdvancedPreferenceViewController()
		]
	)

	func applicationWillFinishLaunching(_ notification: Notification) {
		window.orderOut(self)
	}

	func applicationDidFinishLaunching(_ notification: Notification) {
		preferencesWindowController.showWindow()
	}

	@IBAction func preferencesMenuItemActionHandler(_ sender: NSMenuItem) {
		preferencesWindowController.showWindow()
	}
}
