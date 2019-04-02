import Cocoa

public protocol Preferenceable: AnyObject {
	var toolbarItemTitle: String { get }
	var toolbarItemIdentifier: NSToolbarItem.Identifier { get }
	var toolbarItemIcon: NSImage? { get }
	var viewController: NSViewController { get }
}

extension Preferenceable where Self: NSViewController {
	public var viewController: NSViewController {
		return self
	}
}
