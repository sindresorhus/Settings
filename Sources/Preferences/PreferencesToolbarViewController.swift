import Cocoa

final class PreferencesToolbarViewController: NSObject, PreferenceStyleController {

    let toolbar: NSToolbar
    let centerToolbarItems: Bool
    let preferences: [Preferenceable]

    weak var delegate: PreferenceStyleControllerDelegate?

    init(preferences: [Preferenceable], toolbar: NSToolbar, centerToolbarItems: Bool = true) {
        self.preferences = preferences
        self.toolbar = toolbar
        self.centerToolbarItems = centerToolbarItems
    }

    func toolbarItemIdentifiers() -> [NSToolbarItem.Identifier] {
        var toolbarItemIdentifiers: [NSToolbarItem.Identifier] = []

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

    func toolbarItem(identifier: NSToolbarItem.Identifier) -> NSToolbarItem? {
        guard let preference = preferences.first(where: { $0.toolbarItemIdentifier == identifier }) else { preconditionFailure()}

        let toolbarItem = NSToolbarItem(itemIdentifier: identifier)
        toolbarItem.label = preference.toolbarItemTitle
        toolbarItem.image = preference.toolbarItemIcon
        toolbarItem.target = self
        toolbarItem.action = #selector(PreferencesToolbarViewController.toolbarItemSelected(_:))
        return toolbarItem
    }

    @IBAction func toolbarItemSelected(_ toolbarItem: NSToolbarItem) {
        delegate?.activateTab(toolbarItemIdentifier: toolbarItem.itemIdentifier, animated: true)
    }

    func selectTab(index: Int) {
        toolbar.selectedItemIdentifier = preferences[index].toolbarItemIdentifier
    }

}
