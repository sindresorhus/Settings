import Cocoa

/// A window that allows you to disable all user interactions via `isUserInteractionEnabled`.
///
/// Used to avoid breaking animations when the user clicks too fast. Disable user interactions during
/// animations and you're set.
class UserInteractionPausableWindow: NSWindow {
    var isUserInteractionEnabled: Bool = true

    let pausableUserEventTypes: [NSEvent.EventType] = {
        var result: [NSEvent.EventType] = [
            .leftMouseDown, .leftMouseUp, .rightMouseDown, .rightMouseUp, .leftMouseDragged, .rightMouseDragged,
            .keyDown, .keyUp, .scrollWheel, .tabletPoint, .otherMouseDown, .otherMouseUp, .otherMouseDragged,
            .gesture, .magnify, .swipe, .rotate, .beginGesture, .endGesture, .smartMagnify, .quickLook, .directTouch
        ]

        if #available(macOS 10.10.3, *) {
            result.append(.pressure)
        }

        return result
    }()

    override func sendEvent(_ event: NSEvent) {
        if !isUserInteractionEnabled && pausableUserEventTypes.contains(event.type) {
            return
        }

        super.sendEvent(event)
    }
}
