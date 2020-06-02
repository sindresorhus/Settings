import Cocoa
import Preferences

extension Preferences.PaneIdentifier {
	static let general = Self("general")
	static let advanced = Self("advanced")
	static let userAccounts = Self("userAccounts")
}

@NSApplicationMain
final class AppDelegate: NSObject, NSApplicationDelegate {
	@IBOutlet private var window: NSWindow!

	var preferencesStyle: PreferencesStyle {
		get { PreferencesStyle.preferencesStyleFromUserDefaults() }
		set {
			newValue.storeInUserDefaults()
		}
	}

	lazy var preferences: [PreferencePane] = [
		GeneralPreferenceViewController(),
		AdvancedPreferenceViewController(),
		UserAccountsPreferenceViewController()
	]

	lazy var preferencesWindowController = PreferencesWindowController(
		preferencePanes: preferences,
		style: preferencesStyle,
		animated: true,
		hidesToolbarForSingleItem: true
	)

	func applicationWillFinishLaunching(_ notification: Notification) {
		window.orderOut(self)
	}

	func applicationDidFinishLaunching(_ notification: Notification) {
		preferencesWindowController.show(preferencePane: .userAccounts)
	}

	@IBAction private func preferencesMenuItemActionHandler(_ sender: NSMenuItem) {
		preferencesWindowController.show()
	}

	@IBAction private func switchStyle(_ sender: Any) {
		preferencesStyle = preferencesStyle == .segmentedControl
			? .toolbarItems
			: .segmentedControl

		NSApp.relaunch()
	}
}
