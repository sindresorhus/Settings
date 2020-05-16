//
//  PreferencePane+SwiftUI.swift
//  Preferences
//
//  Created by Kacper on 06/01/2020.
//

import Foundation
import SwiftUI

/**
SwiftUI equivelent of `PreferencePane` protocol.
*/
@available(macOS 10.15, *)
public protocol _PreferencePaneView: View {
	var preferencePaneIdentifier: PreferencePane.Identifier { get }
	var preferencePaneTitle: String { get }
	var toolbarItemIcon: NSImage { get }
}

/**
`enum` acting as a namespace for SwiftUI components.
*/
@available(macOS 10.15, *)
public enum Preferences {
	public typealias PaneView = _PreferencePaneView

	/**
	Hosting controller enabling `Preferences.PaneView` to be used alongside AppKit NSViewControllers.
	*/
	public final class PaneHostingController<Content: PaneView>: NSHostingController<Content>, PreferencePane {
		public let preferencePaneIdentifier: Identifier
		public let preferencePaneTitle: String
		public let toolbarItemIcon: NSImage

		public init(preferencePaneView: Content) {
			self.preferencePaneIdentifier = preferencePaneView.preferencePaneIdentifier
			self.preferencePaneTitle = preferencePaneView.preferencePaneTitle
			self.toolbarItemIcon = preferencePaneView.toolbarItemIcon
			super.init(rootView: preferencePaneView)
		}

		@available(*, unavailable)
		@objc
		dynamic required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
	}
}
