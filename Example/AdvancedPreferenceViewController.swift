import Cocoa
import Preferences

final class AdvancedPreferenceViewController: NSViewController, PreferencePane {
	let preferencePaneIdentifier = Preferences.PaneIdentifier.advanced
	let preferencePaneTitle = "Advanced"
	let toolbarItemIcon = NSImage(systemSymbolName: "gearshape.2", accessibilityDescription: "Advanced preferences")!

	override var nibName: NSNib.Name? { "AdvancedPreferenceViewController" }

	override func viewDidLoad() {
		super.viewDidLoad()

		// Setup stuff here
	}

	@IBAction
	private func zoomAction(_ sender: Any) {} // swiftlint:disable:this attributes
}
