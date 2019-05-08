import Cocoa

public struct PreferencePaneIdentifier: Hashable, RawRepresentable {
	public typealias Identifier = PreferencePaneIdentifier

	public let rawValue: String

	public init(rawValue: String) {
		self.rawValue = rawValue
	}
}

public protocol PreferencePane: AnyObject {
	typealias Identifier = PreferencePaneIdentifier

	var preferencePaneIdentifier: Identifier { get }
	var preferencePaneTitle: String { get }
	var toolbarItemIcon: NSImage { get }
	var viewController: NSViewController { get }
}

extension PreferencePane where Self: NSViewController {
	public var viewController: NSViewController {
		return self
	}
}

extension PreferencePane {
	public var toolbarItemIdentifier: NSToolbarItem.Identifier {
		return preferencePaneIdentifier.toolbarItemIdentifier
	}

	public var toolbarItemIcon: NSImage {
		return NSImage(size: .zero)
	}
}

extension PreferencePane.Identifier {
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
