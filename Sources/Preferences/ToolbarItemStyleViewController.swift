import Cocoa

final class ToolbarItemStyleViewController: NSObject, PreferencesStyleController {
	let toolbar: NSToolbar
	let centerToolbarItems: Bool
	let preferences: [PreferencePane]

	var isKeepingWindowCentered: Bool {
		return centerToolbarItems
	}

	weak var delegate: PreferencesStyleControllerDelegate?

	init(preferences: [PreferencePane], toolbar: NSToolbar, centerToolbarItems: Bool) {
		self.preferences = preferences
		self.toolbar = toolbar
		self.centerToolbarItems = centerToolbarItems
	}

	func toolbarItemIdentifiers() -> [NSToolbarItem.Identifier] {
		var toolbarItemIdentifiers = [NSToolbarItem.Identifier]()

		if centerToolbarItems {
			toolbarItemIdentifiers.append(.flexibleSpace)
		}

		for preference in preferences {
			toolbarItemIdentifiers.append(preference.toolbarItemIdentifier)
		}

		if centerToolbarItems {
			toolbarItemIdentifiers.append(.flexibleSpace)
		}

		return toolbarItemIdentifiers
	}

	func toolbarItem(preferenceIdentifier: PreferencePaneIdentifier) -> NSToolbarItem? {
		guard let preference = (preferences.first { $0.preferencePaneIdentifier == preferenceIdentifier }) else {
			preconditionFailure()
		}

		let toolbarItem = NSToolbarItem(itemIdentifier: preferenceIdentifier.toolbarItemIdentifier)
		toolbarItem.label = preference.toolbarItemTitle
		toolbarItem.image = preference.toolbarItemIcon
		toolbarItem.target = self
		toolbarItem.action = #selector(toolbarItemSelected)
		return toolbarItem
	}

	@IBAction private func toolbarItemSelected(_ toolbarItem: NSToolbarItem) {
		delegate?.activateTab(
			preferenceIdentifier: PreferencePaneIdentifier(fromToolbarItemIdentifier: toolbarItem.itemIdentifier),
			animated: true
		)
	}

	func selectTab(index: Int) {
		toolbar.selectedItemIdentifier = preferences[index].toolbarItemIdentifier
	}
}
