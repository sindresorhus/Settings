import Cocoa
import Preferences

final class AdvancedPreferenceViewController: NSViewController, Preferenceable {
	let toolbarItemTitle = "Advanced"
	let toolbarItemIcon: NSImage? = NSImage(named: NSImage.advancedName)!

	override var nibName: NSNib.Name? {
		return "AdvancedPreferenceViewController"
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		// Setup stuff here
	}
}
