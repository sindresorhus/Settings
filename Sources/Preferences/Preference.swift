import Cocoa

public struct PreferenceIdentifier: Equatable, RawRepresentable {
	public let rawValue: String

	public init(rawValue: String) {
		self.rawValue = rawValue
	}
}

public protocol Preference: AnyObject {
	var preferenceIdentifier: PreferenceIdentifier { get }
	var toolbarItemTitle: String { get }
	var toolbarItemIcon: NSImage { get }
	var viewController: NSViewController { get }
}

extension Preference where Self: NSViewController {
	public var viewController: NSViewController {
		return self
	}
}

extension Preference {
	public var toolbarItemIdentifier: NSToolbarItem.Identifier {
		return preferenceIdentifier.toolbarItemIdentifier
	}

	public var toolbarItemIcon: NSImage {
		return NSImage(size: .zero)
	}
}

extension PreferenceIdentifier {
	public init(_ rawValue: String) {
		self.init(rawValue: rawValue)
	}

	public init(fromToolbarItemIdentifier itemIdentifier: NSToolbarItem.Identifier) {
		self.init(rawValue: itemIdentifier.rawValue)
	}

	public var toolbarItemIdentifier: NSToolbarItem.Identifier {
		return NSToolbarItem.Identifier(rawValue)
	}
}
