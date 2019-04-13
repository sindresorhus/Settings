import Cocoa

extension NSWindow.FrameAutosaveName {
	static let preferences: NSWindow.FrameAutosaveName = "com.sindresorhus.Preferences.FrameAutosaveName-WIP-1"
}

public final class PreferencesWindowController: NSWindowController {
	private let tabViewController = PreferencesTabViewController()

	public var isAnimated: Bool {
		get {
			return tabViewController.isAnimated
		}
		set {
			tabViewController.isAnimated = newValue
		}
	}

	public init(
		preferencePanes: [PreferencePane],
		style: PreferencesStyle = .toolbarItems,
		animated: Bool = true
	) {
		precondition(!preferencePanes.isEmpty, "You need to set at least one view controller")

		let window = UserInteractionPausableWindow(
			contentRect: preferencePanes[0].viewController.view.bounds,
			styleMask: [
				.titled,
				.closable
			],
			backing: .buffered,
			defer: true
		)
		super.init(window: window)

		window.contentViewController = tabViewController
		tabViewController.isAnimated = animated
		tabViewController.configure(preferencePanes: preferencePanes)
		changePreferencesStyle(to: style)
	}

	@available(*, unavailable)
	override public init(window: NSWindow?) {
		fatalError("init(window:) is not supported, use init(preferences:style:animated:)")
	}

	@available(*, unavailable)
	public required init?(coder: NSCoder) {
		fatalError("init(coder:) is not supported, use init(preferences:style:animated:)")
	}

	private func changePreferencesStyle(to newStyle: PreferencesStyle) {
		window?.titleVisibility = newStyle.windowTitleVisibility
		tabViewController.changePreferencesStyle(to: newStyle)
	}

	/// Show the preferences window and brings it to front.
	///
	/// If you pass a `PreferencePaneIdentifier`, the window will activate the corresponding tab.
	///
	/// - See `close()` to close the window again.
	/// - See `showWindow(_:)` to show the window without the convenience of activating the app.
	/// - Note: Unless you need to open a specific pane, prefer not to pass a parameter at all
	/// - Parameter preferencePane: Identifier of the preference pane to display.
	public func show(preferencePane preferenceIdentifier: PreferencePaneIdentifier? = nil) {
		centerWindowOnFirstStart()
		showWindow(self)
		tabViewController.activateTab(preferenceIdentifier: preferenceIdentifier, animated: false)
		NSApp.activate(ignoringOtherApps: true)
	}

	private func centerWindowOnFirstStart() {
		guard let window = self.window else {
			return
		}

		// When setting the autosave name, the current position isn't stored immediately.
		// Trying to read the frame values will fail, so we can center it.
		window.setFrameAutosaveName(.preferences)
		if window.setFrameUsingName(.preferences) == false {
			window.center()
		}
	}
}
