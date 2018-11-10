import Cocoa

public enum PreferencesStyle {
    case tabs
    case segmentedControl

    internal var tabStyle: NSTabViewController.TabStyle {
        switch self {
        case .tabs:
            return .toolbar
        case .segmentedControl:
            return .segmentedControlOnTop
        }
    }
}
