import Cocoa

final class PreferencesToolbarViewController: NSObject, PreferenceStyleController {

    var centerToolbarItems: Bool = true
    let preferences: [Preferenceable]
    var selectedTab: Int = 0

    weak var delegate: PreferenceStyleControllerDelegate?

    init(preferences: [Preferenceable]) {
        self.preferences = preferences
    }

    func toolbarItemIdentifiers() -> [NSToolbarItem.Identifier] {
        var toolbarItemIdentifiers: [NSToolbarItem.Identifier] = []

        if centerToolbarItems {
            toolbarItemIdentifiers.append(.flexibleSpace)
        }

        for preference in preferences {
            toolbarItemIdentifiers.append(NSToolbarItem.Identifier(rawValue: preference.toolbarItemTitle))
        }

        if centerToolbarItems {
            toolbarItemIdentifiers.append(.flexibleSpace)
        }

        return toolbarItemIdentifiers
    }

    func toolbarItem(identifier: NSToolbarItem.Identifier) -> NSToolbarItem? {
        guard let (index, preference) = preferences.enumerated().first(where: { $0.element.toolbarItemTitle == identifier.rawValue }) else { preconditionFailure()}

        let toolbarItem = NSToolbarItem(itemIdentifier: identifier)
        toolbarItem.tag = index
        toolbarItem.label = preference.toolbarItemTitle
        toolbarItem.image = preference.toolbarItemIcon
        toolbarItem.target = self
        toolbarItem.action = #selector(PreferencesToolbarViewController.toolbarItemSelected(_:))
        return toolbarItem
    }

    @IBAction func toolbarItemSelected(_ toolbarItem: NSToolbarItem) {
        let index = toolbarItem.tag
        selectedTab = index
        delegate?.activateTab(index: index, animated: true)
    }
}
