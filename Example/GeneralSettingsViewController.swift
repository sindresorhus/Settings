import Cocoa
import Preferences

final class GeneralSettingsViewController: NSViewController, SettingsPane {
	let paneIdentifier = Settings.PaneIdentifier.general
	let paneTitle = "General"
	let toolbarItemIcon = NSImage(systemSymbolName: "gearshape", accessibilityDescription: "General settings")!

	override var nibName: NSNib.Name? { "GeneralSettingsViewController" }

	override func viewDidLoad() {
		super.viewDidLoad()

		// Setup stuff here
	}
}
