import Cocoa

public enum PreferencesStyle {
	public enum SegmentSize {
		case fit
		case uniform
	}
	
	case toolbarItems
	case segmentedControl(size: SegmentSize)
}
