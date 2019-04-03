import Cocoa
import Preferences

extension PreferencePaneIdentifier {
	static let general = PreferencePaneIdentifier("general")
	static let advanced = PreferencePaneIdentifier("advanced")
}

@NSApplicationMain
final class AppDelegate: NSObject, NSApplicationDelegate {
	@IBOutlet private var window: NSWindow!

	var preferencesStyle: PreferencesStyle {
		get {
			return PreferencesStyle.preferencesStyleFromUserDefaults()
		}
		set(newPreferencesStyle) {
			newPreferencesStyle.storeInUserDefaults()
		}
	}

	lazy var preferences: [PreferencePane] = [
		GeneralPreferenceViewController(),
		AdvancedPreferenceViewController()
	]
	lazy var preferencesWindowController = PreferencesWindowController(preferencePanes: self.preferences, style: self.preferencesStyle, animated: true)

	func applicationWillFinishLaunching(_ notification: Notification) {
		window.orderOut(self)
	}

	func applicationDidFinishLaunching(_ notification: Notification) {
		preferencesWindowController.showPreference(preferencePane: .advanced)
	}

	@IBAction private func preferencesMenuItemActionHandler(_ sender: NSMenuItem) {
		preferencesWindowController.showPreference()
	}

	@IBAction private func switchStyle(_ sender: Any) {
		self.preferencesStyle = (self.preferencesStyle == .segmentedControl)
        	? .toolbarItems
			: .segmentedControl
		relaunch()
	}
}

private func relaunch() {
	let appBundleIdentifier = Bundle.main.bundleIdentifier!
	NSWorkspace.shared.launchApplication(
		withBundleIdentifier: appBundleIdentifier,
		options: NSWorkspace.LaunchOptions.newInstance,
		additionalEventParamDescriptor: nil,
		launchIdentifier: nil)
	NSApp.terminate(nil)
}
