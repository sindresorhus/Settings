import Foundation
import Preferences

// Helpers to write styles to and read them from UserDefaults.

extension PreferencesStyle: RawRepresentable {
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

extension PreferencesStyle {
    static var userDefaultsKey: String { return "preferencesStyle" }

    static func preferencesStyleFromUserDefaults(_ userDefaults: UserDefaults = .standard) -> PreferencesStyle {
        return PreferencesStyle(rawValue: userDefaults.integer(forKey: PreferencesStyle.userDefaultsKey))
            ?? .toolbarItems
    }

    func storeInUserDefaults(_ userDefaults: UserDefaults = .standard) {
        userDefaults.set(self.rawValue, forKey: PreferencesStyle.userDefaultsKey)
    }
}
