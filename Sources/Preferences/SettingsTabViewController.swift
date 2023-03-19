import Cocoa

final class SettingsTabViewController: NSViewController, SettingsStyleControllerDelegate {
	private var activeTab: Int?
	private var panes = [SettingsPane]()
	private var style: Settings.Style?
	internal var settingsPanesCount: Int { panes.count }
	private var settingsStyleController: SettingsStyleController!
	private var isKeepingWindowCentered: Bool { settingsStyleController.isKeepingWindowCentered }

	private var toolbarItemIdentifiers: [NSToolbarItem.Identifier] {
		settingsStyleController?.toolbarItemIdentifiers() ?? []
	}

	var window: NSWindow! { view.window }

	var isAnimated = true

	var activeViewController: NSViewController? {
		guard let activeTab else {
			return nil
		}

		return panes[activeTab]
	}

	override func loadView() {
		view = NSView()
		view.translatesAutoresizingMaskIntoConstraints = false
	}

	func configure(panes: [SettingsPane], style: Settings.Style) {
		self.panes = panes
		self.style = style
		children = panes

		let toolbar = NSToolbar(identifier: "SettingsToolbar")
		toolbar.allowsUserCustomization = false
		toolbar.displayMode = .iconAndLabel
		toolbar.showsBaselineSeparator = true
		toolbar.delegate = self

		switch style {
		case .segmentedControl:
			settingsStyleController = SegmentedControlStyleViewController(panes: panes)
		case .toolbarItems:
			settingsStyleController = ToolbarItemStyleViewController(
				panes: panes,
				toolbar: toolbar,
				centerToolbarItems: false
			)
		}
		settingsStyleController.delegate = self

		// Called last so that `settingsStyleController` can be asked for items.
		window.toolbar = toolbar
	}

	func activateTab(paneIdentifier: Settings.PaneIdentifier, animated: Bool) {
		guard let index = (panes.firstIndex { $0.paneIdentifier == paneIdentifier }) else {
			return activateTab(index: 0, animated: animated)
		}

		activateTab(index: index, animated: animated)
	}

	func activateTab(index: Int, animated: Bool) {
		defer {
			activeTab = index
			settingsStyleController.selectTab(index: index)
			updateWindowTitle(tabIndex: index)
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
		window.title = {
			if panes.count > 1 {
				return panes[tabIndex].paneTitle
			} else {
				let settings: String
				if #available(macOS 13, *) {
					settings = Localization[.settings]
				} else {
					settings = Localization[.preferences]
				}

				let appName = Bundle.main.appName
				return "\(appName) \(settings)"
			}
		}()
	}

	/**
	Cached constraints that pin `childViewController` views to the content view.
	*/
	private var activeChildViewConstraints = [NSLayoutConstraint]()

	private func immediatelyDisplayTab(index: Int) {
		let toViewController = panes[index]
		view.addSubview(toViewController.view)
		activeChildViewConstraints = toViewController.view.constrainToSuperviewBounds()
		setWindowFrame(for: toViewController, animated: false)
	}

	private func animateTabTransition(index: Int, animated: Bool) {
		guard let activeTab else {
			assertionFailure("animateTabTransition called before a tab was displayed; transition only works from one tab to another")
			immediatelyDisplayTab(index: index)
			return
		}

		let fromViewController = panes[activeTab]
		let toViewController = panes[index]

		// View controller animations only work on macOS 10.14 and newer.
		let options: NSViewController.TransitionOptions
		if #available(macOS 10.14, *) {
			options = animated && isAnimated ? [.crossfade] : []
		} else {
			options = []
		}

		view.removeConstraints(activeChildViewConstraints)

		transition(
			from: fromViewController,
			to: toViewController,
			options: options
		) { [self] in
			activeChildViewConstraints = toViewController.view.constrainToSuperviewBounds()
		}
	}

	override func transition(
		from fromViewController: NSViewController,
		to toViewController: NSViewController,
		options: NSViewController.TransitionOptions = [],
		completionHandler completion: (() -> Void)? = nil
	) {
		let isAnimated = options
			.isSubset(of: [
				.crossfade,
				.slideUp,
				.slideDown,
				.slideForward,
				.slideBackward,
				.slideLeft,
				.slideRight
			])

		if isAnimated {
			NSAnimationContext.runAnimationGroup({ context in
				context.allowsImplicitAnimation = true
				context.duration = 0.25
				context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
				setWindowFrame(for: toViewController, animated: true)

				super.transition(
					from: fromViewController,
					to: toViewController,
					options: options,
					completionHandler: completion
				)
			}, completionHandler: nil)
		} else {
			super.transition(
				from: fromViewController,
				to: toViewController,
				options: options,
				completionHandler: completion
			)
		}
	}

	private func setWindowFrame(for viewController: NSViewController, animated: Bool = false) {
		guard let window else {
			preconditionFailure()
		}

		let contentSize = viewController.view.fittingSize

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

extension SettingsTabViewController: NSToolbarDelegate {
	func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		toolbarItemIdentifiers
	}

	func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		toolbarItemIdentifiers
	}

	func toolbarSelectableItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		style == .segmentedControl ? [] : toolbarItemIdentifiers
	}

	public func toolbar(
		_ toolbar: NSToolbar,
		itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
		willBeInsertedIntoToolbar flag: Bool
	) -> NSToolbarItem? {
		if itemIdentifier == .flexibleSpace {
			return nil
		}

		return settingsStyleController.toolbarItem(paneIdentifier: .init(fromToolbarItemIdentifier: itemIdentifier))
	}
}
