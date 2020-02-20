import Cocoa

extension NSToolbarItem.Identifier {
	static var toolbarSegmentedControlItem: NSToolbarItem.Identifier {
		NSToolbarItem.Identifier("toolbarSegmentedControlItem")
	}
}

extension NSUserInterfaceItemIdentifier {
	static var toolbarSegmentedControl: NSUserInterfaceItemIdentifier {
		NSUserInterfaceItemIdentifier("toolbarSegmentedControl")
	}
}

final class SegmentedControlStyleViewController: NSViewController, PreferencesStyleController {
	var segmentedControl: NSSegmentedControl! {
		get { view as? NSSegmentedControl }
		set {
			view = newValue
		}
	}

	var isKeepingWindowCentered: Bool { true }

	weak var delegate: PreferencesStyleControllerDelegate?

	private var segmentSize: PreferencesStyle.SegmentSize!
	private var preferencePanes: [PreferencePane]!

	required init(preferencePanes: [PreferencePane], segmentSize: PreferencesStyle.SegmentSize) {
		super.init(nibName: nil, bundle: nil)
		self.preferencePanes = preferencePanes
		self.segmentSize = segmentSize
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func loadView() {
		view = createSegmentedControl(preferencePanes: preferencePanes)
		sizeSegmentedControl()
	}

	fileprivate func createSegmentedControl(preferencePanes: [PreferencePane]) -> NSSegmentedControl {
		let segmentedControl = NSSegmentedControl()
		segmentedControl.segmentCount = preferencePanes.count
		segmentedControl.segmentStyle = .texturedSquare
		segmentedControl.target = self
		segmentedControl.action = #selector(segmentedControlAction)
		segmentedControl.identifier = .toolbarSegmentedControl

		if let cell = segmentedControl.cell as? NSSegmentedCell {
			cell.controlSize = .regular
			cell.trackingMode = .selectOne
		}

		return segmentedControl
	}

	private func sizeSegmentedControl() {
		switch self.segmentSize! {
		case .fit:
			sizeSegmentedControlToFit()
		case .uniform:
			sizeSegmentedControlUniformly()
		}
	}

	private func sizeSegmentedControlUniformly() {
		let insets = CGSize(width: 36, height: 12)
		let maxSegmentSize: CGSize = preferencePanes.reduce(.zero) { maxSize, preferencePane in
			let title = preferencePane.preferencePaneTitle
			let titleSize = title.size(
				withAttributes: [
					.font: NSFont.systemFont(ofSize: NSFont.systemFontSize(for: .regular))
				]
			)

			return CGSize(
				width: max(titleSize.width + insets.width, maxSize.width),
				height: max(titleSize.height + insets.height, maxSize.height)
			)
		}

		let segmentBorderWidth = CGFloat(preferencePanes.count) + 1
		let segmentedControlWidth = maxSegmentSize.width * CGFloat(preferencePanes.count) + segmentBorderWidth
		let segmentedControlHeight = maxSegmentSize.height

		for (index, preferencePane) in preferencePanes.enumerated() {
			segmentedControl.setLabel(preferencePane.preferencePaneTitle, forSegment: index)
			segmentedControl.setWidth(maxSegmentSize.width, forSegment: index)
			if let cell = segmentedControl.cell as? NSSegmentedCell {
				cell.setTag(index, forSegment: index)
			}
		}

		segmentedControl.frame = CGRect(
			x: 0, y: 0,
			width: segmentedControlWidth, height: segmentedControlHeight)
	}

	private func sizeSegmentedControlToFit() {
		let insets = CGSize(width: 8, height: 0)
		let segmentSizes: [CGSize] = preferencePanes.map { preferencePane in
			let title = preferencePane.preferencePaneTitle
			let titleSize = title.size(
				withAttributes: [
					.font: NSFont.systemFont(ofSize: NSFont.systemFontSize(for: .regular))
				]
			)

			let maxSize = CGSize(
				width: max(titleSize.width, 0),
				height: max(titleSize.height, 0)
			)
			return CGSize(
				width: maxSize.width + insets.width,
				height: maxSize.height + insets.height
			)
		}

		let segmentBorderWidth = CGFloat(preferencePanes.count) + 1
		let segmentedControlWidth: CGFloat = segmentSizes.reduce(0) { $0 + $1.width } + segmentBorderWidth
		let segmentedControlHeight = segmentSizes.map { $0.height }.max() ?? 0

		for (index, preferencePane) in preferencePanes.enumerated() {
			segmentedControl.setLabel(preferencePane.preferencePaneTitle, forSegment: index)
			segmentedControl.setWidth(segmentSizes[index].width, forSegment: index)
			if let cell = segmentedControl.cell as? NSSegmentedCell {
				cell.setTag(index, forSegment: index)
			}
		}

		segmentedControl.frame = CGRect(
			x: 0, y: 0,
			width: segmentedControlWidth, height: segmentedControlHeight)
	}

	@IBAction private func segmentedControlAction(_ control: NSSegmentedControl) {
		delegate?.activateTab(index: control.selectedSegment, animated: true)
	}

	func selectTab(index: Int) {
		segmentedControl.selectedSegment = index
	}

	func toolbarItemIdentifiers() -> [NSToolbarItem.Identifier] {
		[
			.flexibleSpace,
			.toolbarSegmentedControlItem,
			.flexibleSpace
		]
	}

	func toolbarItem(preferenceIdentifier: PreferencePane.Identifier) -> NSToolbarItem? {
		let toolbarItemIdentifier = preferenceIdentifier.toolbarItemIdentifier
		precondition(toolbarItemIdentifier == .toolbarSegmentedControlItem)

		// When the segments outgrow the window, we need to provide a group of
		// NSToolbarItems with custom menu item labels and action handling for the
		// context menu that pops up at the right edge of the window.
		let toolbarItemGroup = NSToolbarItemGroup(itemIdentifier: toolbarItemIdentifier)
		toolbarItemGroup.view = segmentedControl
		toolbarItemGroup.subitems = preferencePanes.enumerated().map { index, preferenceable -> NSToolbarItem in
			let item = NSToolbarItem(itemIdentifier: .init("segment-\(preferenceable.preferencePaneTitle)"))
			item.label = preferenceable.preferencePaneTitle

			let menuItem = NSMenuItem(
				title: preferenceable.preferencePaneTitle,
				action: #selector(segmentedControlMenuAction),
				keyEquivalent: ""
			)
			menuItem.tag = index
			menuItem.target = self
			item.menuFormRepresentation = menuItem

			return item
		}

		return toolbarItemGroup
	}

	@IBAction private func segmentedControlMenuAction(_ menuItem: NSMenuItem) {
		delegate?.activateTab(index: menuItem.tag, animated: true)
	}
}
