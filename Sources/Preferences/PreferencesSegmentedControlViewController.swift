import Cocoa

extension NSToolbarItem.Identifier {
    static var toolbarSegmentedControlItem: NSToolbarItem.Identifier {
        return NSToolbarItem.Identifier(rawValue: "toolbarSegmentedControlItem")
    }
}

extension NSUserInterfaceItemIdentifier {
    static var toolbarSegmentedControl: NSUserInterfaceItemIdentifier {
        return NSUserInterfaceItemIdentifier(rawValue: "toolbarSegmentedControl")
    }
}

final class PreferencesSegmentedControlViewController: NSViewController, PreferenceStyleController {
    var segmentedControl: NSSegmentedControl! {
        get {
            return view as? NSSegmentedControl
        }
        set {
            view = newValue
        }
    }

    weak var delegate: PreferenceStyleControllerDelegate?

    private var preferences: [Preferenceable]!

    required init(preferences: [Preferenceable]) {
        super.init(nibName: nil, bundle: nil)
        self.preferences = preferences
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = createSegmentedControl(preferences: self.preferences)
    }

    fileprivate func createSegmentedControl(preferences: [Preferenceable]) -> NSSegmentedControl {
        let segmentedControl = NSSegmentedControl()
        segmentedControl.segmentCount = preferences.count
        segmentedControl.segmentStyle = .texturedSquare
        segmentedControl.target = self
        segmentedControl.action = #selector(PreferencesSegmentedControlViewController.segmentedControlAction(_:))
        segmentedControl.identifier = .toolbarSegmentedControl

        if let cell = segmentedControl.cell as? NSSegmentedCell {
            cell.controlSize = .regular
            cell.trackingMode = .selectOne
        }

        let segmentSize: NSSize = {
            let insets = NSSize(width: 36, height: 12)
            var maxSize = NSSize(width: 0, height: 0)

            for preference in preferences {
                let title = preference.toolbarItemTitle
                let titleSize = title.size(withAttributes: [.font: NSFont.systemFont(ofSize: NSFont.systemFontSize(for: .regular))])

                maxSize = NSSize(width: max(titleSize.width, maxSize.width),
                                 height: max(titleSize.height, maxSize.height))
            }

            return NSSize(width: maxSize.width + insets.width,
                          height: maxSize.height + insets.height)
        }()

        let segmentBorderWidth = CGFloat(preferences.count) + 1.0
        let segmentWidth = segmentSize.width * CGFloat(preferences.count) + segmentBorderWidth
        let segmentHeight = segmentSize.height
        segmentedControl.frame = NSRect(x: 0, y: 0, width: segmentWidth, height: segmentHeight)

        for (index, preference) in preferences.enumerated() {
            segmentedControl.setLabel(preference.toolbarItemTitle, forSegment: index)
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
        return [
            .flexibleSpace,
            .toolbarSegmentedControlItem,
            .flexibleSpace
        ]
    }

    func toolbarItem(identifier: NSToolbarItem.Identifier) -> NSToolbarItem? {
        precondition(identifier == .toolbarSegmentedControlItem)

        // When the segments outgrow the window, we need to provide a group of
        // NSToolbarItems with custom menu item labels and action handling for the
        // context menu that pops up at the right edge of the window.
        let toolbarItemGroup = NSToolbarItemGroup(itemIdentifier: identifier)
        toolbarItemGroup.view = segmentedControl
        toolbarItemGroup.subitems = preferences.enumerated().map { index, preferenceable -> NSToolbarItem in
            let item = NSToolbarItem(itemIdentifier: .init(rawValue: "segment-\(preferenceable.toolbarItemTitle)"))
            item.label = preferenceable.toolbarItemTitle

            let menuItem = NSMenuItem(
                title: preferenceable.toolbarItemTitle,
                action: #selector(segmentedControlMenuAction(_:)),
                keyEquivalent: "")
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
