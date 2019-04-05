import Cocoa

struct System {
	/// Get a system localized string
	/// Use https://itunes.apple.com/no/app/system-strings/id570467776 to find strings
	static func localizedString(forKey key: String) -> String {
		return Bundle(for: NSApplication.self).localizedString(forKey: key, value: nil, table: nil)
	}
}

extension NSObject {
	/// Returns the class name without module name
	class var simpleClassName: String {
		return String(describing: self)
	}

	/// Returns the class name of the instance without module name
	var simpleClassName: String {
		return type(of: self).simpleClassName
	}
}

extension Collection {
	func map<T, U>(_ transform: (Element) throws -> (key: T, value: U)) rethrows -> [T: U] {
		var result: [T: U] = [:]
		for element in self {
			let transformation = try transform(element)
			result[transformation.key] = transformation.value
		}
		return result
	}
}

extension NSView {
	@discardableResult
	func constrainToSuperviewBounds() -> [NSLayoutConstraint] {
		guard let superview = superview else {
			preconditionFailure("superview has to be set first")
		}

		var result = [NSLayoutConstraint]()
		result.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
		result.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
		translatesAutoresizingMaskIntoConstraints = false
		superview.addConstraints(result)

		return result
	}
}

extension NSEvent {
	/// Events triggered by user interaction.
	static let userInteractionEvents: [NSEvent.EventType] = {
		var events: [NSEvent.EventType] = [
			.leftMouseDown,
			.leftMouseUp,
			.rightMouseDown,
			.rightMouseUp,
			.leftMouseDragged,
			.rightMouseDragged,
			.keyDown,
			.keyUp,
			.scrollWheel,
			.tabletPoint,
			.otherMouseDown,
			.otherMouseUp,
			.otherMouseDragged,
			.gesture,
			.magnify,
			.swipe,
			.rotate,
			.beginGesture,
			.endGesture,
			.smartMagnify,
			.quickLook,
			.directTouch
		]

		if #available(macOS 10.10.3, *) {
			events.append(.pressure)
		}

		return events
	}()

	/// Whether the event was triggered by user interaction.
	var isUserInteraction: Bool {
		return NSEvent.userInteractionEvents.contains(type)
	}
}
