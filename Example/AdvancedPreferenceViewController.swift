import Cocoa
import Preferences

final class AdvancedPreferenceViewController: NSViewController, Preferenceable {
	let toolbarItemTitle = "Advanced"
	let toolbarItemIcon = NSImage(named: .advanced)!

	override var nibName: NSNib.Name? {
		return NSNib.Name("AdvancedPreferenceViewController")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		// Setup stuff here
	}
}
