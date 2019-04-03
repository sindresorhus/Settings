import Cocoa

final class PreferencesTabViewController: NSViewController, PreferencesStyleControllerDelegate {
	private var activeTab: Int!
	private var preferencePanes = [PreferencePane]()

	private var preferencesStyleController: PreferencesStyleController!

	private var isKeepingWindowCentered: Bool {
		return preferencesStyleController.isKeepingWindowCentered
	}

	private var toolbarItemIdentifiers: [NSToolbarItem.Identifier] {
		return preferencesStyleController?.toolbarItemIdentifiers() ?? []
	}

	var window: NSWindow! {
		return view.window
	}

	var isAnimated: Bool = true

	override func loadView() {
		self.view = NSView()
		self.view.translatesAutoresizingMaskIntoConstraints = false
	}

	func configure(preferencePanes: [PreferencePane]) {
		self.preferencePanes = preferencePanes
		self.children = preferencePanes.map { $0.viewController }
	}

	func changePreferencesStyle(to newStyle: PreferencesStyle) {
		changePreferencesStyleController(preferences: self.preferencePanes, style: newStyle)
	}

	private func changePreferencesStyleController(preferences: [PreferencePane], style: PreferencesStyle) {
		let toolbar = NSToolbar(identifier: "PreferencesToolbar")
		toolbar.allowsUserCustomization = false
		toolbar.displayMode = .iconAndLabel
		toolbar.showsBaselineSeparator = true
		toolbar.delegate = self

		switch style {
		case .segmentedControl:
			preferencesStyleController = SegmentedControlStyleViewController(preferences: preferences)
		case .toolbarItems:
			preferencesStyleController = ToolbarItemStyleViewController(
				preferences: preferences,
				toolbar: toolbar,
				centerToolbarItems: false
			)
		}
		preferencesStyleController.delegate = self

		// Called last so that `preferencesStyleController` can be asked for items
		window.toolbar = toolbar
	}

	func activateTab(preference: PreferencePane?, animated: Bool) {
		guard let preference = preference else {
			return activateTab(index: 0, animated: animated)
		}

		activateTab(preferenceIdentifier: preference.preferencePaneIdentifier, animated: animated)
	}

	func activateTab(preferenceIdentifier: PreferencePaneIdentifier?, animated: Bool) {
		guard
			let preferenceIdentifier = preferenceIdentifier,
			let index = (preferencePanes.firstIndex { $0.preferencePaneIdentifier == preferenceIdentifier })
		else {
			return activateTab(index: 0, animated: animated)
		}

		activateTab(index: index, animated: animated)
	}

	func activateTab(index: Int, animated: Bool) {
		defer {
			activeTab = index
			preferencesStyleController.selectTab(index: index)
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

	/// Cached constraints that pin childViewController views to the content view
	private var activeChildViewConstraints = [NSLayoutConstraint]()

	private func immediatelyDisplayTab(index: Int) {
		let toViewController = children[index]
		view.addSubview(toViewController.view)
		activeChildViewConstraints = toViewController.view.constrainToSuperviewBounds()
		setWindowFrame(for: toViewController, animated: false)
	}

	private func animateTabTransition(index: Int, animated: Bool) {
		let fromViewController = children[activeTab]
		let toViewController = children[index]
		let options: NSViewController.TransitionOptions = animated && isAnimated
			? [.crossfade]
			: []

		view.removeConstraints(activeChildViewConstraints)

		transition(
			from: fromViewController,
			to: toViewController,
			options: options
		) {
			self.activeChildViewConstraints = toViewController.view.constrainToSuperviewBounds()
		}
	}

	override func transition(
		from fromViewController: NSViewController,
		to toViewController: NSViewController,
		options: NSViewController.TransitionOptions = [],
		completionHandler completion: (() -> Void)? = nil
	) {
		let isAnimated = options
			.intersection([
				.crossfade,
				.slideUp,
				.slideDown,
				.slideForward,
				.slideBackward,
				.slideLeft,
				.slideRight
			])
			.isEmpty == false

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
		guard let window = window else {
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

extension PreferencesTabViewController: NSToolbarDelegate {
	func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		return toolbarItemIdentifiers
	}

	func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		return toolbarItemIdentifiers
	}

	func toolbarSelectableItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		return toolbarItemIdentifiers
	}

	public func toolbar(
		_ toolbar: NSToolbar,
		itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
		willBeInsertedIntoToolbar flag: Bool
	) -> NSToolbarItem? {
		if itemIdentifier == .flexibleSpace {
			return nil
		}

		return preferencesStyleController.toolbarItem(preferenceIdentifier: PreferencePaneIdentifier(fromToolbarItemIdentifier: itemIdentifier))
	}
}

extension NSWindow {
	var effectiveMinSize: CGSize {
		return contentMinSize != .zero
			? frameRect(forContentRect: CGRect(origin: .zero, size: contentMinSize)).size
			: minSize
	}
}
