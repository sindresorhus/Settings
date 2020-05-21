//
//  PreferencePane+SwiftUI.swift
//  Preferences
//
//  Created by Kacper on 06/01/2020.
//

import Foundation
import SwiftUI

/**
`enum` acting as a namespace for SwiftUI components.
*/
@available(macOS 10.15, *)
public enum Preferences {
	/**
	SwiftUI equivelent of `PreferencePane` protocol. Create this using your custom content view.
	Contains all the necessary information for single preference pane.
	*/
	public struct PaneView<Content: View>: View {
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
	}

	/**
	Hosting controller enabling `Preferences.PaneView` to be used alongside AppKit NSViewControllers.
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

		public convenience init(paneView: PaneView<Content>) {
			self.init(
				identifier: paneView.identifier,
				title: paneView.title,
				toolbarIcon: paneView.toolbarIcon,
				content: paneView.content
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
	public convenience init<T: View>(
		paneViews: [Preferences.PaneView<T>],
		style: PreferencesStyle = .toolbarItems,
		animated: Bool = true,
		hidesToolbarForSingleItem: Bool = true
	) {
		let panes = paneViews.map { Preferences.PaneHostingController(paneView: $0) }
		self.init(
			preferencePanes: panes,
			style: style,
			animated: animated,
			hidesToolbarForSingleItem: hidesToolbarForSingleItem
		)
	}
}
