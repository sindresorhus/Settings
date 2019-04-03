import Cocoa

protocol PreferenceStyleController: AnyObject {
    var delegate: PreferenceStyleControllerDelegate? { get set }

    func toolbarItemIdentifiers() -> [NSToolbarItem.Identifier]
    func toolbarItem(preferenceIdentifier: PreferencePaneIdentifier) -> NSToolbarItem?

    func selectTab(index: Int)
}

protocol PreferenceStyleControllerDelegate: AnyObject {
    func activateTab(preferenceIdentifier: PreferencePaneIdentifier?, animated: Bool)
    func activateTab(index: Int, animated: Bool)
}
