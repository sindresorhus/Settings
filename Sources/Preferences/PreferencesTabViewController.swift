import Cocoa

protocol PreferenceStyleController: AnyObject {
	var delegate: PreferenceStyleControllerDelegate? { get set }

	func toolbarItemIdentifiers() -> [NSToolbarItem.Identifier]
	func toolbarItem(identifier: NSToolbarItem.Identifier) -> NSToolbarItem?

	func selectTab(index: Int)
}

protocol PreferenceStyleControllerDelegate: AnyObject {
	func activateTab(toolbarItemIdentifier: NSToolbarItem.Identifier?, animated: Bool)
	func activateTab(index: Int, animated: Bool)
}

final class PreferencesTabViewController: NSViewController, PreferenceStyleControllerDelegate {
	private var activeTab: Int!
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


	func activateTab(preference: Preferenceable?, animated: Bool) {
		guard let preference = preference else {
			return activateTab(index: 0, animated: animated)
		}
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
			guard index != activeTab else {
				return
			}
			animateTabTransition(index: index, animated: animated)
		}
	}

	/// Cached constraints that pin childViewController views to the content view
	private var activeChildViewConstraints: [NSLayoutConstraint] = []

	private func immediatelyDisplayTab(index: Int) {
		let toViewController = children[index]
		view.addSubview(toViewController.view)
		activeChildViewConstraints = toViewController.view.constrainToSuperviewBounds()
		setWindowFrame(for: toViewController, animated: false)
	}

	private func animateTabTransition(index: Int, animated: Bool) {
		let fromViewController = children[activeTab]
		let toViewController = children[index]
		let options: NSViewController.TransitionOptions = animated && isCrossfadingTransitions
			? [.crossfade]
			: []

		view.removeConstraints(activeChildViewConstraints)

		transition(
			from: fromViewController,
			to: toViewController,
			options: options) {
				self.activeChildViewConstraints = toViewController.view.constrainToSuperviewBounds()
		}
	}

	override func transition(from fromViewController: NSViewController, to toViewController: NSViewController, options: NSViewController.TransitionOptions = [], completionHandler completion: (() -> Void)? = nil) {
		let isAnimated = options
			.intersection([.crossfade, .slideUp, .slideDown, .slideForward, .slideBackward, .slideLeft, .slideRight])
			.isEmpty == false

		if isAnimated {
			NSAnimationContext.runAnimationGroup({ context in
				context.allowsImplicitAnimation = true
				context.duration = 0.25
				context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
				setWindowFrame(for: toViewController, animated: true)
				super.transition(from: fromViewController, to: toViewController, options: options, completionHandler: completion)
			}, completionHandler: nil)
		} else {
			super.transition(from: fromViewController, to: toViewController, options: options, completionHandler: completion)
		}
	}

	private func setWindowFrame(for viewController: NSViewController, animated: Bool = false) {
		guard let window = window else { preconditionFailure() }
		let contentSize = viewController.view.fittingSize

		let newWindowSize = window.frameRect(forContentRect: CGRect(origin: .zero, size: contentSize)).size
		var frame = window.frame
		frame.origin.y += frame.height - newWindowSize.height
		frame.size = newWindowSize

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
