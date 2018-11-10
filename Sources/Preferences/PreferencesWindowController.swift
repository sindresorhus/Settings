import Cocoa

public final class PreferencesWindowController: NSWindowController {
	private let tabViewController = PreferencesTabViewController()

	public init(preferences: [Preferenceable], style: PreferencesStyle = .tabs) {
		precondition(!preferences.isEmpty, "You need to set at least one view controller")

		let window = NSWindow(
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
		window.contentView = tabViewController.view

		tabViewController.configure(preferences: preferences, style: style)
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	public func showWindow() {
		if !window!.isVisible {
			window?.center()
		}

		showWindow(self)
		NSApp.activate(ignoringOtherApps: true)
	}

	public func hideWindow() {
		close()
	}
}
