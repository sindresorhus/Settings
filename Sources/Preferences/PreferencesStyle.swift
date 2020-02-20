import Cocoa

public enum PreferencesStyle {
	public enum SegmentSize {
		case fit, uniform
	}
	
	case toolbarItems
	case segmentedControl(size: SegmentSize)
}
