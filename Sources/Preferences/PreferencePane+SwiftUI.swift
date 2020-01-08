//
//  PreferencePane+SwiftUI.swift
//  Preferences
//
//  Created by Kacper on 06/01/2020.
//

import Foundation
import SwiftUI

@available (macOS 10.15, *)
public final class PreferencePaneHostingController<Content: View>: NSHostingController<Content>, PreferencePane {
	public let preferencePaneIdentifier: Identifier
	public let preferencePaneTitle: String
	public let toolbarItemIcon: NSImage
    
	public init(
		identifier: Identifier,
		title: String,
		toolbarIcon: NSImage = .empty,
		content: Content
	) {
		self.preferencePaneIdentifier = identifier
		self.preferencePaneTitle = title
		self.toolbarItemIcon = toolbarIcon
		super.init(rootView: content)
	}
    
	@available(*, unavailable)
	@objc required dynamic init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
