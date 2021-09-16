import SwiftUI

/**
Represents a type that can be converted to `SettingsPane`.

Acts as type-eraser for `Settings.Pane<T>`.
*/
public protocol SettingsPaneConvertible {
	/**
	Convert `self` to equivalent `SettingsPane`.
	*/
	func asPreferencePane() -> SettingsPane
}

@available(macOS 10.15, *)
extension Settings {
	/**
	Create a SwiftUI-based settings pane.

	SwiftUI equivalent of the `SettingsPane` protocol.
	*/
	public struct Pane<Content: View>: View, SettingsPaneConvertible {
		let identifier: PaneIdentifier
		let title: String
		let toolbarIcon: NSImage
		let content: Content

		public init(
			identifier: PaneIdentifier,
			title: String,
			toolbarIcon: NSImage,
			contentView: () -> Content
		) {
			self.identifier = identifier
			self.title = title
			self.toolbarIcon = toolbarIcon
			self.content = contentView()
		}

		public var body: some View { content }

		public func asPreferencePane() -> SettingsPane {
			PaneHostingController(pane: self)
		}
	}

	/**
	Hosting controller enabling `Settings.Pane` to be used alongside AppKit `NSViewController`'s.
	*/
	public final class PaneHostingController<Content: View>: NSHostingController<Content>, SettingsPane {
		public let preferencePaneIdentifier: PaneIdentifier
		public let preferencePaneTitle: String
		public let toolbarItemIcon: NSImage

		init(
			identifier: PaneIdentifier,
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
extension View {
	/**
	Applies font and color for a label used for describing a setting.
	*/
	public func preferenceDescription() -> some View {
		font(.system(size: 11.0))
			// TODO: Use `.foregroundStyle` when targeting macOS 12.
			.foregroundColor(.secondary)
	}
}
