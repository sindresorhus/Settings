import Cocoa
import Preferences

final class GeneralPreferenceViewController: NSViewController, Preferenceable {
	let toolbarItemTitle = "General"
	let toolbarItemIcon = NSImage(named: .preferencesGeneral)!

	override var nibName: NSNib.Name? {
		return NSNib.Name("GeneralPreferenceViewController")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		// Setup stuff here
	}
}
