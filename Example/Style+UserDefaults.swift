import Foundation
import Settings

// Helpers to write styles to and read them from UserDefaults.

extension Settings.Style: RawRepresentable {
	public var rawValue: Int {
		switch self {
		case .toolbarItems:
			return 0
		case .segmentedControl:
			return 1
		}
	}

	public init?(rawValue: Int) {
		switch rawValue {
		case 0:
			self = .toolbarItems
		case 1:
			self = .segmentedControl
		default:
			return nil
		}
	}
}

extension Settings.Style {
	static let userDefaultsKey = "settingsStyle"

	static func settingsStyleFromUserDefaults(_ userDefaults: UserDefaults = .standard) -> Self {
		Self(rawValue: userDefaults.integer(forKey: userDefaultsKey))
			?? .toolbarItems
	}

	func storeInUserDefaults(_ userDefaults: UserDefaults = .standard) {
		userDefaults.set(rawValue, forKey: Self.userDefaultsKey)
	}
}
