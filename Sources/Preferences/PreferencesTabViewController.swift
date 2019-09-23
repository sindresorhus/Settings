import Cocoa

final class PreferencesTabViewController: NSViewController, PreferencesStyleControllerDelegate {
	private var activeTab: Int?
	private var preferencePanes = [PreferencePane]()
	internal var preferencePanesCount: Int { preferencePanes.count }
	private var preferencesStyleController: PreferencesStyleController!
	private var isKeepingWindowCentered: Bool { preferencesStyleController.isKeepingWindowCentered }

	private var toolbarItemIdentifiers: [NSToolbarItem.Identifier] {
		preferencesStyleController?.toolbarItemIdentifiers() ?? []
	}

	private var viewSizeCache = [PreferencePaneIdentifier: CGSize]()

	var window: NSWindow! { view.window }

	override func loadView() {
		self.view = NSView()
		self.view.translatesAutoresizingMaskIntoConstraints = false
	}

	func configure(preferencePanes: [PreferencePane], style: PreferencesStyle) {
		self.preferencePanes = preferencePanes
		self.children = preferencePanes

		let toolbar = NSToolbar(identifier: "PreferencesToolbar")
		toolbar.allowsUserCustomization = false
		toolbar.displayMode = .iconAndLabel
		toolbar.showsBaselineSeparator = true
		toolbar.delegate = self

		switch style {
		case .segmentedControl:
			preferencesStyleController = SegmentedControlStyleViewController(preferencePanes: preferencePanes)
		case .toolbarItems:
			preferencesStyleController = ToolbarItemStyleViewController(
				preferencePanes: preferencePanes,
				toolbar: toolbar,
				centerToolbarItems: false
			)
		}
		preferencesStyleController.delegate = self

		// Called last so that `preferencesStyleController` can be asked for items.
		window.toolbar = toolbar
	}

	func activateTab(preferencePane: PreferencePane, animated: Bool) {
		activateTab(preferenceIdentifier: preferencePane.preferencePaneIdentifier, animated: animated)
	}

	func activateTab(preferenceIdentifier: PreferencePane.Identifier, animated: Bool) {
		guard let index = (preferencePanes.firstIndex { $0.preferencePaneIdentifier == preferenceIdentifier }) else {
			return activateTab(index: 0, animated: animated)
		}

		activateTab(index: index, animated: animated)
	}

	func activateTab(index: Int, animated: Bool) {
		defer {
			activeTab = index
			preferencesStyleController.selectTab(index: index)
			updateWindowTitle(tabIndex: index)
			setWindowFrame(for: preferencePanes[index].viewController, animated: animated)
		}

		if activeTab == nil {
			immediatelyDisplayTab(index: index)
		} else {
			guard index != activeTab else {
				return
			}

			animateTabTransition(index: index, animated: animated)
		}
	}

	func restoreInitialTab() {
		if activeTab == nil {
			activateTab(index: 0, animated: false)
		}
	}

	private func updateWindowTitle(tabIndex: Int) {
		self.window.title = {
			if preferencePanes.count > 1 {
				return preferencePanes[tabIndex].preferencePaneTitle
			} else {
				let preferences = Localization[.preferences]
				let appName = Bundle.main.appName
				return "\(appName) \(preferences)"
			}
		}()
	}

	/// Cached constraints that pin `childViewController` views to the content view.
	private var activeChildViewConstraints = [NSLayoutConstraint]()

	private func immediatelyDisplayTab(index: Int) {
		let toViewController = preferencePanes[index]
		view.addSubview(toViewController.view)
		activeChildViewConstraints = toViewController.view.constrainToSuperviewBounds()
		setWindowFrame(for: toViewController, animated: false)
	}

	private func animateTabTransition(index: Int, animated: Bool) {
		guard let activeTab = activeTab else {
			assertionFailure("animateTabTransition called before a tab was displayed; transition only works from one tab to another")
			immediatelyDisplayTab(index: index)
			return
		}

		let fromViewController = children[activeTab]
		let toViewController = children[index]

		view.removeConstraints(activeChildViewConstraints)

		fromViewController.view.layer?.opacity = 0
		toViewController.view.layer?.opacity = 0
		transition(
			from: fromViewController,
			to: toViewController,
			options: []
		) {
			toViewController.view.layer?.opacity = 1
			self.activeChildViewConstraints = toViewController.view.constrainToSuperviewBounds()
		}
	}

	override func transition(
		from fromViewController: NSViewController,
		to toViewController: NSViewController,
		options: NSViewController.TransitionOptions = [],
		completionHandler completion: (() -> Void)? = nil
	) {
		super.transition(
			from: fromViewController,
			to: toViewController,
			options: [],
			completionHandler: completion
		)
	}

	private func setWindowFrame(for viewController: NSViewController, animated: Bool = false) {
		guard
			let window = window,
			let preferencePane = preferencePanes.first(where: { $0.viewController == viewController })
		else {
			preconditionFailure()
		}

		var contentSize = CGSize.zero
		if let cachedSize = self.viewSizeCache[preferencePane.preferencePaneIdentifier] {
			contentSize = cachedSize
		} else {
			contentSize = viewController.view.bounds.size

			self.viewSizeCache[preferencePane.preferencePaneIdentifier] = contentSize
		}

		let newWindowSize = window.frameRect(forContentRect: CGRect(origin: .zero, size: contentSize)).size
		var frame = window.frame
		frame.origin.y += frame.height - newWindowSize.height
		frame.size = newWindowSize

		if isKeepingWindowCentered {
			let horizontalDiff = (window.frame.width - newWindowSize.width) / 2
			frame.origin.x += horizontalDiff
		}

		let animatableWindow = animated ? window.animator() : window
		animatableWindow.setFrame(frame, display: false)
	}
}

extension PreferencesTabViewController: NSToolbarDelegate {
	func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		toolbarItemIdentifiers
	}

	func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		toolbarItemIdentifiers
	}

	func toolbarSelectableItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		toolbarItemIdentifiers
	}

	public func toolbar(
		_ toolbar: NSToolbar,
		itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
		willBeInsertedIntoToolbar flag: Bool
	) -> NSToolbarItem? {
		if itemIdentifier == .flexibleSpace {
			return nil
		}

		return preferencesStyleController.toolbarItem(preferenceIdentifier: .Identifier(fromToolbarItemIdentifier: itemIdentifier))
	}
}
