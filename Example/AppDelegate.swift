import Cocoa
import Settings

extension Settings.PaneIdentifier {
	static let general = Self("general")
	static let accounts = Self("accounts")
	static let advanced = Self("advanced")
}

@main
final class AppDelegate: NSObject, NSApplicationDelegate {
	@IBOutlet private var window: NSWindow!

	private var settingsStyle: Settings.Style {
		get { .settingsStyleFromUserDefaults() }
		set {
			newValue.storeInUserDefaults()
		}
	}

	private lazy var panes: [SettingsPane] = [
		GeneralSettingsViewController(),
		AccountsSettingsViewController(),
		AdvancedSettingsViewController()
	]

	private lazy var settingsWindowController = SettingsWindowController(
		panes: panes,
		style: settingsStyle,
		animated: true,
		hidesToolbarForSingleItem: true
	)

	func applicationWillFinishLaunching(_ notification: Notification) {
		window.orderOut(self)
	}

	func applicationDidFinishLaunching(_ notification: Notification) {
		settingsWindowController.show(pane: .accounts)
	}

	@IBAction private func settingsMenuItemActionHandler(_ sender: NSMenuItem) {
		settingsWindowController.show()
	}

	@IBAction private func switchStyle(_ sender: Any) {
		settingsStyle = settingsStyle == .segmentedControl
			? .toolbarItems
			: .segmentedControl

		Task {
			try! await NSApp.relaunch() // swiftlint:disable:this force_try
		}
	}
}
