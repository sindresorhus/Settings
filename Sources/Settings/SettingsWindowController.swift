import Cocoa

extension NSWindow.FrameAutosaveName {
	static let settings: NSWindow.FrameAutosaveName = "com.sindresorhus.Settings.FrameAutosaveName"
}

public final class SettingsWindowController: NSWindowController {
	private let tabViewController = SettingsTabViewController()

	public var isAnimated: Bool {
		get { tabViewController.isAnimated }
		set {
			tabViewController.isAnimated = newValue
		}
	}

	public var hidesToolbarForSingleItem: Bool {
		didSet {
			updateToolbarVisibility()
		}
	}

	private func updateToolbarVisibility() {
		window?.toolbar?.isVisible = (hidesToolbarForSingleItem == false)
			|| (tabViewController.settingsPanesCount > 1)
	}

	public init(
		panes: [SettingsPane],
		style: Settings.Style = .toolbarItems,
		animated: Bool = true,
		hidesToolbarForSingleItem: Bool = true
	) {
		precondition(!panes.isEmpty, "You need to set at least one pane")

		let window = UserInteractionPausableWindow(
			contentRect: panes[0].view.bounds,
			styleMask: [
				.titled,
				.closable
			],
			backing: .buffered,
			defer: true
		)
		self.hidesToolbarForSingleItem = hidesToolbarForSingleItem
		super.init(window: window)

		window.contentViewController = tabViewController

		window.titleVisibility = {
			switch style {
			case .toolbarItems:
				return .visible
			case .segmentedControl:
				return panes.count <= 1 ? .visible : .hidden
			}
		}()

		if #available(macOS 11.0, *), style == .toolbarItems {
			window.toolbarStyle = .preference
		}

		tabViewController.isAnimated = animated
		tabViewController.configure(panes: panes, style: style)
		updateToolbarVisibility()
	}

	@available(*, unavailable)
	override public init(window: NSWindow?) {
		fatalError("init(window:) is not supported, use init(panes:style:animated:hidesToolbarForSingleItem:)")
	}

	@available(*, unavailable)
	public required init?(coder: NSCoder) {
		fatalError("init(coder:) is not supported, use init(panes:style:animated:hidesToolbarForSingleItem:hidesToolbarForSingleItem:)")
	}


	/**
	Show the settings window and brings it to front.

	If you pass a `Settings.PaneIdentifier`, the window will activate the corresponding tab.

	- Parameter paneIdentifier: Identifier of the settings pane to display, or `nil` to show the tab that was open when the user last closed the window.

	- Note: Unless you need to open a specific pane, prefer not to pass a parameter at all or `nil`.

	- See `close()` to close the window again.
	- See `showWindow(_:)` to show the window without the convenience of activating the app.
	*/
	public func show(pane paneIdentifier: Settings.PaneIdentifier? = nil) {
		if let paneIdentifier {
			tabViewController.activateTab(paneIdentifier: paneIdentifier, animated: false)
		} else {
			tabViewController.restoreInitialTab()
		}

		showWindow(self)
		restoreWindowPosition()
		NSApp.activate(ignoringOtherApps: true)
	}

	private func restoreWindowPosition() {
		guard
			let window,
			let screenContainingWindow = window.screen
		else {
			return
		}

		window.setFrameOrigin(CGPoint(
			x: screenContainingWindow.visibleFrame.midX - window.frame.width / 2,
			y: screenContainingWindow.visibleFrame.midY - window.frame.height / 2
		))
		window.setFrameUsingName(.settings)
		window.setFrameAutosaveName(.settings)
	}
}

extension SettingsWindowController {
	/**
	Returns the active pane if it responds to the given action.
	*/
	override public func supplementalTarget(forAction action: Selector, sender: Any?) -> Any? {
		if let target = super.supplementalTarget(forAction: action, sender: sender) {
			return target
		}

		guard let activeViewController = tabViewController.activeViewController else {
			return nil
		}

		if let target = NSApp.target(forAction: action, to: activeViewController, from: sender) as? NSResponder, target.responds(to: action) {
			return target
		}

		if let target = activeViewController.supplementalTarget(forAction: action, sender: sender) as? NSResponder, target.responds(to: action) {
			return target
		}

		return nil
	}
}

@available(macOS 10.15, *)
extension SettingsWindowController {
	/**
	Create a settings window from only SwiftUI-based settings panes.
	*/
	public convenience init(
		panes: [SettingsPaneConvertible],
		style: Settings.Style = .toolbarItems,
		animated: Bool = true,
		hidesToolbarForSingleItem: Bool = true
	) {
		self.init(
			panes: panes.map { $0.asSettingsPane() },
			style: style,
			animated: animated,
			hidesToolbarForSingleItem: hidesToolbarForSingleItem
		)
	}
}
