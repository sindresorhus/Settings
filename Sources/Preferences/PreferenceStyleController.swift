import Cocoa

protocol PreferenceStyleController: AnyObject {
    var delegate: PreferenceStyleControllerDelegate? { get set }

    func toolbarItemIdentifiers() -> [NSToolbarItem.Identifier]
    func toolbarItem(preferenceIdentifier: PreferenceIdentifier) -> NSToolbarItem?

    func selectTab(index: Int)
}

protocol PreferenceStyleControllerDelegate: AnyObject {
    func activateTab(preferenceIdentifier: PreferenceIdentifier?, animated: Bool)
    func activateTab(index: Int, animated: Bool)
}
