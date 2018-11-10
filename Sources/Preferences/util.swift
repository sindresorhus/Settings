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
