import Cocoa

protocol PreferencesStyleController: AnyObject {
    var delegate: PreferencesStyleControllerDelegate? { get set }

    func toolbarItemIdentifiers() -> [NSToolbarItem.Identifier]
    func toolbarItem(preferenceIdentifier: PreferencePaneIdentifier) -> NSToolbarItem?

    func selectTab(index: Int)
}

protocol PreferencesStyleControllerDelegate: AnyObject {
    func activateTab(preferenceIdentifier: PreferencePaneIdentifier?, animated: Bool)
    func activateTab(index: Int, animated: Bool)
}
