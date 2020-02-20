import Cocoa
import Preferences

extension PreferencePane.Identifier {
	static let general = Identifier("general")
	static let advanced = Identifier("advanced")
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
		AdvancedPreferenceViewController()
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
		preferencesWindowController.show(preferencePane: .advanced)
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
