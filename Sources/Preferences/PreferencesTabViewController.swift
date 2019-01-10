import Cocoa

protocol PreferenceStyleController: class {
	var delegate: PreferenceStyleControllerDelegate? { get set }

	func toolbarItemIdentifiers() -> [NSToolbarItem.Identifier]
	func toolbarItem(identifier: NSToolbarItem.Identifier) -> NSToolbarItem?

	func selectTab(index: Int)
}

protocol PreferenceStyleControllerDelegate: class {
	func activateTab(toolbarItemIdentifier: NSToolbarItem.Identifier?, animated: Bool)
	func activateTab(index: Int, animated: Bool)
}

final class PreferencesTabViewController: NSViewController, PreferenceStyleControllerDelegate {

	private var activeTab: Int!
	private var tabViewSizes: [String: CGSize] = [:]
	private var preferences: [Preferenceable] = []

	private var toolbarItemIdentifiers: [NSToolbarItem.Identifier] = []

	private var preferencesStyleController: PreferenceStyleController! {
		didSet {
			toolbarItemIdentifiers = preferencesStyleController.toolbarItemIdentifiers()
		}
	}

	var window: NSWindow! {
		return view.window
	}

	var isCrossfadingTransitions: Bool = true

	override func loadView() {
		self.view = NSView()
		self.view.translatesAutoresizingMaskIntoConstraints = false
	}

	func configure(preferences: [Preferenceable], style: PreferencesStyle) {
		self.preferences = preferences
		self.tabViewSizes = preferences.map { preference -> (String, CGSize) in
			return (preference.viewController.simpleClassName,
					preference.viewController.view.frame.size)
		}

		self.children = preferences.map { $0.viewController }

		let toolbar = NSToolbar(identifier: "PreferencesToolbar")
		toolbar.allowsUserCustomization = false
		toolbar.displayMode = .iconAndLabel
		toolbar.showsBaselineSeparator = true
		toolbar.delegate = self

		self.preferencesStyleController = {
			switch style {
			case .segmentedControl:
				return PreferencesSegmentedControlViewController(preferences: preferences)
			case .tabs:
				return PreferencesToolbarViewController(preferences: preferences, toolbar: toolbar, centerToolbarItems: true)
			}
		}()
		self.preferencesStyleController.delegate = self

		self.window.toolbar = toolbar // Call latest so that preferencesStyleController can be asked for items
	}

	private func setWindowFrame(for viewController: NSViewController, animated: Bool = true) {
		guard let window = window else { preconditionFailure() }
		guard let contentSize = tabViewSizes[viewController.simpleClassName] else {
			preconditionFailure("Call configure(preferences:style:) first")
		}

		let desiredContentSize = window.frameRect(forContentRect: CGRect(origin: .zero, size: contentSize)).size
		let minWindowSize: NSSize = window.effectiveMinSize
		let newWindowSize = NSSize(
			width: max(desiredContentSize.width, minWindowSize.width),
			height: max(desiredContentSize.height, minWindowSize.height))

		var frame = window.frame
		frame.origin.y += frame.height - newWindowSize.height
		frame.size = newWindowSize
		let animatableWindow = animated ? window.animator() : window
		animatableWindow.setFrame(frame, display: false)
	}

	func activateTab(preference: Preferenceable?, animated: Bool) {
		guard let preference = preference else { return activateTab(index: 0, animated: animated) }
		activateTab(toolbarItemIdentifier: preference.toolbarItemIdentifier, animated: animated)
	}

	func activateTab(toolbarItemIdentifier: NSToolbarItem.Identifier?, animated: Bool) {
		guard let toolbarItemIdentifier = toolbarItemIdentifier,
			  let index = preferences.firstIndex(where: { $0.toolbarItemIdentifier == toolbarItemIdentifier })
			  else { return activateTab(index: 0, animated: animated) }
		activateTab(index: index, animated: animated)
	}

	func activateTab(index: Int, animated: Bool) {
		defer {
			activeTab = index
			preferencesStyleController.selectTab(index: index)
		}

		if self.activeTab == nil {
			immediatelyDisplayTab(index: index)
		} else {
			guard index != activeTab else { return }
			animateTabTransition(index: index, animated: animated)
		}
	}

	private func immediatelyDisplayTab(index: Int) {
		let toViewController = children[index]
		view.addSubview(toViewController.view)
		toViewController.view.constrainToSuperviewBounds()
		toViewController.view.alphaValue = 1.0
		setWindowFrame(for: toViewController, animated: false)
	}

	private func animateTabTransition(index: Int, animated: Bool) {
		let fromViewController = children[activeTab]
		let toViewController = children[index]

		guard self.isCrossfadingTransitions else {
			return immediatelyTransition(fromViewController: fromViewController,
										 toViewController: toViewController)
		}

		animateTransition(fromViewController: fromViewController,
						  toViewController: toViewController,
						  animated: animated)
	}

	private func immediatelyTransition(fromViewController: NSViewController, toViewController: NSViewController) {
		fromViewController.view.removeFromSuperview()
		view.addSubview(toViewController.view)
		toViewController.view.constrainToSuperviewBounds()
		self.setWindowFrame(for: toViewController)
	}

	private func animateTransition(fromViewController: NSViewController, toViewController: NSViewController, animated: Bool) {
		guard let window = self.window as? PausableWindow else {
			return immediatelyTransition(fromViewController: fromViewController,
										 toViewController: toViewController)
		}

		window.isUserInteractionEnabled = false

		// Remove first so its constraints don't affect the animation
		fromViewController.view.removeFromSuperview()

		toViewController.view.alphaValue = 0
		view.addSubview(toViewController.view)
		toViewController.view.constrainToSuperviewBounds()

		NSAnimationContext.runAnimationGroup({ context in
			context.allowsImplicitAnimation = true
			context.duration = (animated ? 0.25 : 0.0)
			context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
			self.setWindowFrame(for: toViewController, animated: animated)
			toViewController.view.animator().alphaValue = 1.0
		}, completionHandler: {
			window.isUserInteractionEnabled = true
		})
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

	public func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {

		if itemIdentifier == .flexibleSpace {
			return nil
		}

		return preferencesStyleController.toolbarItem(identifier: itemIdentifier)
	}
}

extension NSWindow {
	var effectiveMinSize: NSSize {
		return (contentMinSize != .zero)
			? frameRect(forContentRect: NSRect(origin: .zero, size: contentMinSize)).size
			: minSize
	}
}
