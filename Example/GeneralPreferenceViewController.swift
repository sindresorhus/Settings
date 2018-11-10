import Cocoa
import Preferences

final class GeneralPreferenceViewController: NSViewController, Preferenceable {
	let toolbarItemTitle = "General"
	let toolbarItemIcon: NSImage? = NSImage(named: NSImage.preferencesGeneralName)!
    let toolbarItemIdentifier: NSToolbarItem.Identifier = .preferenceGeneral

	override var nibName: NSNib.Name? {
		return "GeneralPreferenceViewController"
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		// Setup stuff here
	}
}
