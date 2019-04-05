import Cocoa

/// A window that allows you to disable all user interactions via `isUserInteractionEnabled`.
///
/// Used to avoid breaking animations when the user clicks too fast. Disable user interactions during
/// animations and you're set.
class UserInteractionPausableWindow: NSWindow {
	var isUserInteractionEnabled: Bool = true

	override func sendEvent(_ event: NSEvent) {
		guard isUserInteractionEnabled || !event.isUserInteraction else {
			return
		}

		super.sendEvent(event)
	}
}
