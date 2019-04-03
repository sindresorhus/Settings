import Cocoa
import Preferences

final class AdvancedPreferenceViewController: NSViewController, PreferencePane {
	let preferencePaneIdentifier: PreferencePaneIdentifier = .advanced
	let toolbarItemTitle = "Advanced"
	let toolbarItemIcon = NSImage(named: NSImage.advancedName)!

	override var nibName: NSNib.Name? {
		return "AdvancedPreferenceViewController"
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		// Setup stuff here
	}
}
