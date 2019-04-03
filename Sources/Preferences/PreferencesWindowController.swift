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

	public init(preferences: [PreferencePane], style: PreferencesStyle = .toolbarItems, animated: Bool = true) {
		precondition(!preferences.isEmpty, "You need to set at least one view controller")

		let window = UserInteractionPausableWindow(
			contentRect: preferences[0].viewController.view.bounds,
			styleMask: [
				.titled,
				.closable
			],
			backing: .buffered,
			defer: true
		)
		super.init(window: window)

		window.title = String(System.localizedString(forKey: "Preferences…").dropLast())
		window.titleVisibility = style.windowTitleVisibility
		window.contentView = tabViewController.view
		tabViewController.isAnimated = animated
		tabViewController.configure(preferences: preferences, style: style)

	@available(*, unavailable)
	override public init(window: NSWindow?) {
		fatalError("init(window:) is not supported, use init(preferences:style:animated:)")
	}

	@available(*, unavailable)
	public required init?(coder: NSCoder) {
		fatalError("init(coder:) is not supported, use init(preferences:style:animated:)")
	}

	public func changePreferencesStyle(to newStyle: PreferencesStyle) {
		window?.titleVisibility = newStyle.windowTitleVisibility
		tabViewController.changePreferencesStyle(to: newStyle)
	}

	public func showPreference(preferenceIdentifier: PreferencePaneIdentifier? = nil) {
		if !window!.isVisible {
			window?.center()
		}

		showWindow(self)
		tabViewController.activateTab(preferenceIdentifier: preferenceIdentifier, animated: false)
		NSApp.activate(ignoringOtherApps: true)
	}

	public func hideWindow() {
		close()
	}
}
