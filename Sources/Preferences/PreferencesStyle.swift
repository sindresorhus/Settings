import Cocoa

extension Preferences {
	public enum Style {
		public enum SegmentSize {
			case fit
			case uniform
		}

		case toolbarItems
		case segmentedControl(size: SegmentSize)
	}
}
