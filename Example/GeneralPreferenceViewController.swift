import Cocoa
import Preferences

final class GeneralPreferenceViewController: NSViewController, Preference {
    let preferenceIdentifier: PreferenceIdentifier = .general
    let toolbarItemTitle = "General"
    let toolbarItemIcon = NSImage(named: NSImage.preferencesGeneralName)!

	override var nibName: NSNib.Name? {
		return "GeneralPreferenceViewController"
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		// Setup stuff here
	}
}
