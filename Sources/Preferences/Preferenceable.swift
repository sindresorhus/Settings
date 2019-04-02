import Cocoa

public struct PreferenceIdentifier: Equatable, RawRepresentable {
	public let rawValue: String

	public init(rawValue: String) {
		self.rawValue = rawValue
	}
}

public protocol Preferenceable: AnyObject {
	var preferenceIdentifier: PreferenceIdentifier { get }
	var toolbarItemTitle: String { get }
	var toolbarItemIcon: NSImage? { get }
	var viewController: NSViewController { get }
}

extension Preferenceable where Self: NSViewController {
	public var viewController: NSViewController {
		return self
	}
}

extension Preferenceable {
	public var toolbarItemIdentifier: NSToolbarItem.Identifier {
		return preferenceIdentifier.toolbarItemIdentifier
	}
}

extension PreferenceIdentifier {
	public init(fromToolbarItemIdentifier itemIdentifier: NSToolbarItem.Identifier) {
		self.init(rawValue: itemIdentifier.rawValue)
	}

	public var toolbarItemIdentifier: NSToolbarItem.Identifier {
		return NSToolbarItem.Identifier(rawValue)
	}
}
