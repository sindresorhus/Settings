import Cocoa
import Preferences

final class AdvancedSettingsViewController: NSViewController, SettingsPane {
	let preferencePaneIdentifier = Settings.PaneIdentifier.advanced
	let preferencePaneTitle = "Advanced"
	let toolbarItemIcon = NSImage(systemSymbolName: "gearshape.2", accessibilityDescription: "Advanced settings")!

	@IBOutlet private var fontLabel: NSTextField!
	private var font = NSFont.systemFont(ofSize: 14)

	override var nibName: NSNib.Name? { "AdvancedSettingsViewController" }

	override func viewDidLoad() {
		super.viewDidLoad()

		updateFontLabel()
	}

	@IBAction
	private func zoomAction(_ sender: Any) {} // swiftlint:disable:this attributes

	@IBAction
	private func showFontPanel(_ sender: Any) {
		let fontManager = NSFontManager.shared
		fontManager.setSelectedFont(font, isMultiple: false)
		fontManager.orderFrontFontPanel(self)
	}

	@IBAction
	private func changeFont(_ sender: NSFontManager) {
		font = sender.convert(font)
		updateFontLabel()
	}

	private func updateFontLabel() {
		fontLabel.stringValue = font.displayName ?? font.fontName
	}
}
