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

		self.activateTab(index: 0, animated: false)
	}

	private func setWindowFrame(for viewController: NSViewController, animated: Bool = true) {
		guard let window = window else { preconditionFailure() }
		guard let contentSize = tabViewSizes[viewController.simpleClassName] else {
			preconditionFailure("Call configure(preferenceables:style:) first")
		}

		let newWindowSize = window.frameRect(forContentRect: CGRect(origin: .zero, size: contentSize)).size

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
		// No need for `setWindowFrame`: Initial selection will display view at correct size
	}

	private func animateTabTransition(index: Int, animated: Bool) {
		let fromViewController = children[activeTab]
		let toViewController = children[index]

		guard let window = self.window as? PausableWindow else {
			fromViewController.view.removeFromSuperview()
			view.addSubview(toViewController.view)
			toViewController.view.constrainToSuperviewBounds()
			self.setWindowFrame(for: toViewController)
			return
		}
		
		window.isUserInteractionEnabled = false

		toViewController.view.alphaValue = 0
		view.addSubview(toViewController.view)
		toViewController.view.constrainToSuperviewBounds()
		
		NSAnimationContext.runAnimationGroup({ context in
			context.allowsImplicitAnimation = true
			context.duration = (animated ? 0.25 : 0.0)
			context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
			fromViewController.view.animator().alphaValue = 0
			self.setWindowFrame(for: toViewController, animated: animated)
			toViewController.view.animator().alphaValue = 1.0
		}, completionHandler: {
			fromViewController.view.removeFromSuperview()
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
