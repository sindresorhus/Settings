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
		animated: true
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
		preferencesStyle = preferencesStyle == .segmentedControl
			? .toolbarItems
			: .segmentedControl

		relaunch()
	}
}

private func relaunch() {
	NSWorkspace.shared.launchApplication(
		withBundleIdentifier: Bundle.main.bundleIdentifier!,
		options: .newInstance,
		additionalEventParamDescriptor: nil,
		launchIdentifier: nil
	)
	NSApp.terminate(nil)
}
