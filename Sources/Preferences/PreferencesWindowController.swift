import Cocoa

public final class PreferencesWindowController: NSWindowController {
	private let tabViewController = PreferencesTabViewController()

	public init(preferences: [Preferenceable], style: PreferencesStyle = .tabs, crossfadeTransitions: Bool = true) {
		precondition(!preferences.isEmpty, "You need to set at least one view controller")

		let window = PausableWindow(
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
		tabViewController.isCrossfadingTransitions = crossfadeTransitions
		tabViewController.configure(preferences: preferences, style: style)
	}

	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public func showWindow(toolbarItemIdentifier: NSToolbarItem.Identifier? = nil) {
		if !window!.isVisible {
			window?.center()
		}

		showWindow(self)
		tabViewController.activateTab(toolbarItemIdentifier: toolbarItemIdentifier, animated: false)
		NSApp.activate(ignoringOtherApps: true)
	}

	public func hideWindow() {
		close()
	}
}

class PausableWindow: NSWindow {
	var isUserInteractionEnabled: Bool = true

	let userEventTypes: [NSEvent.EventType] = {
		var result: [NSEvent.EventType] = [
			.leftMouseDown, .leftMouseUp, .rightMouseDown, .rightMouseUp, .leftMouseDragged, .rightMouseDragged,
			.keyDown, .keyUp, .scrollWheel, .tabletPoint, .otherMouseDown, .otherMouseUp, .otherMouseDragged,
			.gesture, .magnify, .swipe, .rotate, .beginGesture, .endGesture, .smartMagnify, .quickLook, .directTouch]

		if #available(macOS 10.10.3, *) {
			result.append(.pressure)
		}

		return result
	}()

	override func sendEvent(_ event: NSEvent) {
		if !isUserInteractionEnabled && userEventTypes.contains(event.type) {
			return
		}

		super.sendEvent(event)
	}
}
