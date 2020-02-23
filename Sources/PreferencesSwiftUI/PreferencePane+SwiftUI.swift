//
//  PreferencePane+SwiftUI.swift
//  Preferences
//
//  Created by Kacper on 06/01/2020.
//

import Foundation
import SwiftUI

@available (macOS 10.15, *)
public protocol PreferencePaneView: View {
	var preferencePaneIdentifier: PreferencePane.Identifier { get }
	var preferencePaneTitle: String { get }
	var toolbarItemIcon: NSImage { get }
}

@available (macOS 10.15, *)
public final class PreferencePaneHostingController<Content: PreferencePaneView>: NSHostingController<Content>, PreferencePane {
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
