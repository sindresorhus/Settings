import Cocoa

public enum PreferencesStyle {
    case toolbarItems
    case segmentedControl
}

extension PreferencesStyle {
    var windowTitleVisibility: NSWindow.TitleVisibility {
        switch self {
        case .toolbarItems:
            return .visible
        case .segmentedControl:
            return .hidden
        }
    }
}
