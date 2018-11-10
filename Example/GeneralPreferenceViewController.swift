import Cocoa
import Preferences

final class GeneralPreferenceViewController: NSViewController, Preferenceable {
	let toolbarItemTitle = "General"
	let toolbarItemIcon: NSImage? = NSImage(named: NSImage.preferencesGeneralName)!

	override var nibName: NSNib.Name? {
		return "GeneralPreferenceViewController"
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		// Setup stuff here
	}
}
