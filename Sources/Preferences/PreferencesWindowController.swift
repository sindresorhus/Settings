import Cocoa

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

	public init(preferencePanes: [PreferencePane], style: PreferencesStyle = .toolbarItems, animated: Bool = true) {
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

		window.title = String(System.localizedString(forKey: "Preferences…").dropLast())
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

	public func showPreferences(preferencePane: PreferencePaneIdentifier? = nil) {
		if !window!.isVisible {
			window?.center()
		}

		showWindow(self)
		tabViewController.activateTab(preferenceIdentifier: preferencePane, animated: false)
		NSApp.activate(ignoringOtherApps: true)
	}

	public func hideWindow() {
		close()
	}
}
