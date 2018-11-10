import Cocoa
import Preferences

extension NSToolbarItem.Identifier {
	static var preferenceGeneral: NSToolbarItem.Identifier {
		return NSToolbarItem.Identifier(rawValue: "preferenceGeneral")
	}

	static var preferenceAdvanced: NSToolbarItem.Identifier {
		return NSToolbarItem.Identifier(rawValue: "preferenceAdvanced")
	}
}

@NSApplicationMain
final class AppDelegate: NSObject, NSApplicationDelegate {
	@IBOutlet private var window: NSWindow!

	lazy var preferences: [Preferenceable] = [
		GeneralPreferenceViewController(),
		AdvancedPreferenceViewController()
	]
	lazy var preferencesWindowController: PreferencesWindowController = PreferencesWindowController(preferences: self.preferences, style: .segmentedControl, crossfadeTransitions: true)

	func applicationWillFinishLaunching(_ notification: Notification) {
		window.orderOut(self)
	}

	func applicationDidFinishLaunching(_ notification: Notification) {
		preferencesWindowController.showWindow(toolbarItemIdentifier: .preferenceAdvanced)
	}

	@IBAction private func preferencesMenuItemActionHandler(_ sender: NSMenuItem) {
		preferencesWindowController.showWindow()
	}
}
