import Cocoa

extension NSToolbarItem.Identifier {
	static let toolbarSegmentedControlItem = Self("toolbarSegmentedControlItem")
}

extension NSUserInterfaceItemIdentifier {
	static let toolbarSegmentedControl = Self("toolbarSegmentedControl")
}

final class SegmentedControlStyleViewController: NSViewController, SettingsStyleController {
	var segmentedControl: NSSegmentedControl! {
		get { view as? NSSegmentedControl }
		set {
			view = newValue
		}
	}

	var isKeepingWindowCentered: Bool { true }

	weak var delegate: SettingsStyleControllerDelegate?

	private var panes: [SettingsPane]!

	required init(panes: [SettingsPane]) {
		super.init(nibName: nil, bundle: nil)
		self.panes = panes
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func loadView() {
		view = createSegmentedControl(panes: panes)
	}

	fileprivate func createSegmentedControl(panes: [SettingsPane]) -> NSSegmentedControl {
		let segmentedControl = NSSegmentedControl()
		segmentedControl.segmentCount = panes.count
		segmentedControl.segmentStyle = .texturedSquare
		segmentedControl.target = self
		segmentedControl.action = #selector(segmentedControlAction)
		segmentedControl.identifier = .toolbarSegmentedControl

		if let cell = segmentedControl.cell as? NSSegmentedCell {
			cell.controlSize = .regular
			cell.trackingMode = .selectOne
		}

		let segmentSize: CGSize = {
			let insets = CGSize(width: 36, height: 12)
			var maxSize = CGSize.zero

			for pane in panes {
				let title = pane.paneTitle
				let titleSize = title.size(
					withAttributes: [
						.font: NSFont.systemFont(ofSize: NSFont.systemFontSize(for: .regular))
					]
				)

				maxSize = CGSize(
					width: max(titleSize.width, maxSize.width),
					height: max(titleSize.height, maxSize.height)
				)
			}

			return CGSize(
				width: maxSize.width + insets.width,
				height: maxSize.height + insets.height
			)
		}()

		let segmentBorderWidth = Double(panes.count) + 1
		let segmentWidth = segmentSize.width * Double(panes.count) + segmentBorderWidth
		let segmentHeight = segmentSize.height
		segmentedControl.frame = CGRect(x: 0, y: 0, width: segmentWidth, height: segmentHeight)

		for (index, pane) in panes.enumerated() {
			segmentedControl.setLabel(pane.paneTitle, forSegment: index)
			segmentedControl.setWidth(segmentSize.width, forSegment: index)
			if let cell = segmentedControl.cell as? NSSegmentedCell {
				cell.setTag(index, forSegment: index)
			}
		}

		return segmentedControl
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

	func toolbarItem(paneIdentifier: Settings.PaneIdentifier) -> NSToolbarItem? {
		let toolbarItemIdentifier = paneIdentifier.toolbarItemIdentifier
		precondition(toolbarItemIdentifier == .toolbarSegmentedControlItem)

		// When the segments outgrow the window, we need to provide a group of
		// NSToolbarItems with custom menu item labels and action handling for the
		// context menu that pops up at the right edge of the window.
		let toolbarItemGroup = NSToolbarItemGroup(itemIdentifier: toolbarItemIdentifier)
		toolbarItemGroup.view = segmentedControl
		toolbarItemGroup.subitems = panes.enumerated().map { index, settingsPane -> NSToolbarItem in
			let item = NSToolbarItem(itemIdentifier: .init("segment-\(settingsPane.paneTitle)"))
			item.label = settingsPane.paneTitle

			let menuItem = NSMenuItem(
				title: settingsPane.paneTitle,
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
