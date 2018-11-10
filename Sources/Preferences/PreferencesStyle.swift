import Cocoa

public enum PreferencesStyle {
    case tabs
    case segmentedControl

    var windowTitleVisibility: NSWindow.TitleVisibility {
        switch self {
        case .tabs:
            return .visible
        case .segmentedControl:
            return .hidden
        }
    }
}
