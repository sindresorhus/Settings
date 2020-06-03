import Cocoa
import Preferences

extension Preferences.PaneIdentifier {
	static let general = Self("general")
	static let advanced = Self("advanced")
	static let accounts = Self("accounts")
}

@NSApplicationMain
final class AppDelegate: NSObject, NSApplicationDelegate {
	@IBOutlet private var window: NSWindow!

	var preferencesStyle: Preferences.Style {
		get { .preferencesStyleFromUserDefaults() }
		set {
			newValue.storeInUserDefaults()
		}
	}

	lazy var preferences: [PreferencePane] = [
		GeneralPreferenceViewController(),
		AdvancedPreferenceViewController(),
		AccountsPreferenceViewController()
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
		preferencesWindowController.show(preferencePane: .accounts)
	}

	@IBAction private func preferencesMenuItemActionHandler(_ sender: NSMenuItem) {
		preferencesWindowController.show()
	}

	@IBAction private func switchStyle(_ sender: Any) {
		preferencesStyle = preferencesStyle.rotated
		NSApp.relaunch()
	}
}

extension PreferencesStyle {
	var rotated: PreferencesStyle {
		switch self {
		case .toolbarItems:
			return .segmentedControl(size: .uniform)
		case .segmentedControl(size: .uniform):
			return .segmentedControl(size: .fit)
		case .segmentedControl(size: .fit):
			return .toolbarItems
		}
	}
}
