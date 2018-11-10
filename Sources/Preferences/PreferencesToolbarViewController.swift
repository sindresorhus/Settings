import Cocoa

final class PreferencesToolbarViewController: NSObject, PreferenceStyleController {

    let toolbar: NSToolbar
    let centerToolbarItems: Bool
    let preferences: [Preferenceable]

    var selectedTab: Int = 0 {
        didSet {
            toolbar.selectedItemIdentifier = preferences[selectedTab].toolbarItemIdentifier
        }
    }

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
        let preferenceIndex = toolbarItem.tag
        selectedTab = preferenceIndex
        delegate?.activateTab(index: preferenceIndex, animated: true)
    }
}

fileprivate extension Preferenceable {
    var toolbarItemIdentifier: NSToolbarItem.Identifier {
        return NSToolbarItem.Identifier(rawValue: toolbarItemTitle)
    }
}
