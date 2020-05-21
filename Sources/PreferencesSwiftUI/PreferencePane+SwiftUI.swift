//
//  PreferencePane+SwiftUI.swift
//  Preferences
//
//  Created by Kacper on 06/01/2020.
//

import Foundation
import SwiftUI

/**
Represents object that can be converted to `PreferencePane`.
Acts as type-eraser for `Preferences.Pane<T>`.
*/
public protocol PreferencePaneConvertible {
	/**
	Convert self to equivalent PreferencePane
	*/
	func asPreferencePane() -> PreferencePane
}

/**
`enum` acting as a namespace for SwiftUI components.
*/
@available(macOS 10.15, *)
public enum Preferences {
	/**
	SwiftUI equivelent of `PreferencePane` protocol. Create this using your custom content view.
	Contains all the necessary information for single preference pane.
	*/
	public struct Pane<Content: View>: View, PreferencePaneConvertible {
		public let identifier: PreferencePane.Identifier
		public let title: String
		public let toolbarIcon: NSImage
		public let content: Content

		public init(
			identifier: PreferencePane.Identifier,
			title: String,
			toolbarIcon: NSImage,
			contentView: () -> Content
		) {
			self.identifier = identifier
			self.title = title
			self.toolbarIcon = toolbarIcon
			self.content = contentView()
		}

		public var body: some View {
			content
		}

		public func asPreferencePane() -> PreferencePane {
			PaneHostingController(pane: self)
		}
	}

	/**
	Hosting controller enabling `Preferences.Pane` to be used alongside AppKit NSViewControllers.
	*/
	public final class PaneHostingController<Content: View>: NSHostingController<Content>, PreferencePane {
		public let preferencePaneIdentifier: Identifier
		public let preferencePaneTitle: String
		public let toolbarItemIcon: NSImage

		init(
			identifier: Identifier,
			title: String,
			toolbarIcon: NSImage,
			content: Content
		) {
			self.preferencePaneIdentifier = identifier
			self.preferencePaneTitle = title
			self.toolbarItemIcon = toolbarIcon
			super.init(rootView: content)
		}

		public convenience init(pane: Pane<Content>) {
			self.init(
				identifier: pane.identifier,
				title: pane.title,
				toolbarIcon: pane.toolbarIcon,
				content: pane.content
			)
		}

		@available(*, unavailable)
		@objc
		dynamic required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
	}
}

@available(macOS 10.15, *)
extension PreferencesWindowController {
	/**
	Convenience way to create `PreferencesWindowController` using only SwiftUI views.
	*/
	public convenience init(
		panes: [PreferencePaneConvertible],
		style: PreferencesStyle = .toolbarItems,
		animated: Bool = true,
		hidesToolbarForSingleItem: Bool = true
	) {
		let preferencePanes = panes.map { $0.asPreferencePane() }
		self.init(
			preferencePanes: preferencePanes,
			style: style,
			animated: animated,
			hidesToolbarForSingleItem: hidesToolbarForSingleItem
		)
	}
}
