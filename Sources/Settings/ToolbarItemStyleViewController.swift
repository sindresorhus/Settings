import Cocoa

final class ToolbarItemStyleViewController: NSObject, SettingsStyleController {
	let toolbar: NSToolbar
	let centerToolbarItems: Bool
	let panes: [SettingsPane]
	var isKeepingWindowCentered: Bool { centerToolbarItems }
	weak var delegate: SettingsStyleControllerDelegate?

	init(panes: [SettingsPane], toolbar: NSToolbar, centerToolbarItems: Bool) {
		self.panes = panes
		self.toolbar = toolbar
		self.centerToolbarItems = centerToolbarItems
	}

	func toolbarItemIdentifiers() -> [NSToolbarItem.Identifier] {
		var toolbarItemIdentifiers = [NSToolbarItem.Identifier]()

		if centerToolbarItems {
			toolbarItemIdentifiers.append(.flexibleSpace)
		}

		for pane in panes {
			toolbarItemIdentifiers.append(pane.toolbarItemIdentifier)
		}

		if centerToolbarItems {
			toolbarItemIdentifiers.append(.flexibleSpace)
		}

		return toolbarItemIdentifiers
	}

	func toolbarItem(paneIdentifier: Settings.PaneIdentifier) -> NSToolbarItem? {
		guard let pane = (panes.first { $0.paneIdentifier == paneIdentifier }) else {
			preconditionFailure()
		}

		let toolbarItem = NSToolbarItem(itemIdentifier: paneIdentifier.toolbarItemIdentifier)
		toolbarItem.label = pane.paneTitle
		toolbarItem.image = pane.toolbarItemIcon
		toolbarItem.target = self
		toolbarItem.action = #selector(toolbarItemSelected)
		return toolbarItem
	}

	@IBAction private func toolbarItemSelected(_ toolbarItem: NSToolbarItem) {
		delegate?.activateTab(
			paneIdentifier: .init(fromToolbarItemIdentifier: toolbarItem.itemIdentifier),
			animated: true
		)
	}

	func selectTab(index: Int) {
		toolbar.selectedItemIdentifier = panes[index].toolbarItemIdentifier
	}
}
