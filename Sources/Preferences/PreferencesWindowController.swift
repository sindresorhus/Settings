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

	public var hidesToolbarForSingleItem: Bool {
		didSet {
			updateToolbarVisibility()
		}
	}

	private func updateToolbarVisibility() {
		window?.toolbar?.isVisible = (hidesToolbarForSingleItem == false)
			|| (tabViewController.preferencePanesCount > 1)
	}

	public init(
		preferencePanes: [PreferencePane],
		style: PreferencesStyle = .toolbarItems,
		animated: Bool = true,
		hidesToolbarForSingleItem: Bool = true
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
		self.hidesToolbarForSingleItem = hidesToolbarForSingleItem
		super.init(window: window)

		window.contentViewController = tabViewController
		window.titleVisibility = {
			switch style {
			case .toolbarItems:
				return .visible
			case .segmentedControl:
				return (preferencePanes.count <= 1) ? .visible : .hidden
			}
		}()
		tabViewController.isAnimated = animated
		tabViewController.configure(preferencePanes: preferencePanes, style: style)
		updateToolbarVisibility()
	}

	@available(*, unavailable)
	override public init(window: NSWindow?) {
		fatalError("init(window:) is not supported, use init(preferences:style:animated:)")
	}

	@available(*, unavailable)
	public required init?(coder: NSCoder) {
		fatalError("init(coder:) is not supported, use init(preferences:style:animated:)")
	}


	/// Show the preferences window and brings it to front.
	///
	/// If you pass a `PreferencePaneIdentifier`, the window will activate the corresponding tab.
	///
	/// - See `close()` to close the window again.
	/// - See `showWindow(_:)` to show the window without the convenience of activating the app.
	/// - Note: Unless you need to open a specific pane, prefer not to pass a parameter at all or `nil`.
	/// - Parameter preferencePane: Identifier of the preference pane to display, or `nil` to show the
	///   tab that was open when the user last closed the window.
	public func show(preferencePane preferenceIdentifier: PreferencePaneIdentifier? = nil) {
		if let preferenceIdentifier = preferenceIdentifier {
			tabViewController.activateTab(preferenceIdentifier: preferenceIdentifier, animated: false)
		} else {
			tabViewController.restoreInitialTab()
		}

		showWindow(self)

		centerWindowOnFirstStart()

		NSApp.activate(ignoringOtherApps: true)
	}

	private func centerWindowOnFirstStart() {
		guard let window = self.window,
			let screenContainingWindow = window.screen else {
				return
		}

		// When setting the autosave name, the current position isn't stored immediately.
		// Trying to read the frame values will fail, so we can center it.
		window.setFrameAutosaveName(.preferences)
		if window.setFrameUsingName(.preferences) == false {
			let xPos = screenContainingWindow.frame.midX - window.frame.width / 2
			let yPos = screenContainingWindow.frame.midY - window.frame.height / 2
			window.setFrameOrigin(NSPoint(x: xPos, y: yPos))
		}
	}
}
