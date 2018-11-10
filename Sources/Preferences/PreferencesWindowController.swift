import Cocoa

public final class PreferencesWindowController: NSWindowController {
	private let tabViewController = PreferencesTabViewController()

	public init(viewControllers: [Preferenceable], style: PreferencesStyle = .tabs) {
		precondition(!viewControllers.isEmpty, "You need to set at least one view controller")

		let window = NSWindow(
			contentRect: (viewControllers[0] as! NSViewController).view.bounds,
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

		tabViewController.configure(preferenceables: viewControllers, style: style)
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
