import Foundation
import Preferences

// Helpers to write styles to and read them from UserDefaults.

extension PreferencesStyle: RawRepresentable {
	public var rawValue: Int {
		switch self {
		case .toolbarItems:
			return 0
		case .segmentedControl(size: .uniform):
			return 1
		case .segmentedControl(size: .fit):
			return 2
		}
	}

	public init?(rawValue: Int) {
		switch rawValue {
		case 0:
			self = .toolbarItems
		case 1:
			self = .segmentedControl(size: .uniform)
		case 2:
			self = .segmentedControl(size: .fit)
		default:
			return nil
		}
	}
}

extension PreferencesStyle {
	static let userDefaultsKey = "preferencesStyle"

	static func preferencesStyleFromUserDefaults(_ userDefaults: UserDefaults = .standard) -> Self {
		Self(rawValue: userDefaults.integer(forKey: userDefaultsKey))
			?? .toolbarItems
	}

	func storeInUserDefaults(_ userDefaults: UserDefaults = .standard) {
		userDefaults.set(rawValue, forKey: Self.userDefaultsKey)
	}
}
