import Cocoa
import Preferences

extension PreferenceIdentifier {
	static let general = PreferenceIdentifier("general")
	static let advanced = PreferenceIdentifier("advanced")
}

@NSApplicationMain
final class AppDelegate: NSObject, NSApplicationDelegate {
	@IBOutlet private var window: NSWindow!

	lazy var preferences: [Preferenceable] = [
		GeneralPreferenceViewController(),
		AdvancedPreferenceViewController()
	]
	lazy var preferencesWindowController = PreferencesWindowController(preferences: self.preferences, style: .segmentedControl, crossfadeTransitions: true)

	func applicationWillFinishLaunching(_ notification: Notification) {
		window.orderOut(self)
	}

	func applicationDidFinishLaunching(_ notification: Notification) {
		preferencesWindowController.showWindow(preferenceIdentifier: .advanced)
	}

	@IBAction private func preferencesMenuItemActionHandler(_ sender: NSMenuItem) {
		preferencesWindowController.showWindow()
	}
}
