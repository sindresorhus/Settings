import Cocoa

final class PreferencesTabViewController: NSTabViewController {
	private var tabViewSizes = [String: CGSize]()

	private func setWindowFrame(for viewController: NSViewController) {
		guard let contentSize = tabViewSizes[viewController.simpleClassName] else {
			preconditionFailure("Call configure(preferenceables:style:) first")
		}

		let window = view.window!
		let newWindowSize = window.frameRect(forContentRect: CGRect(origin: .zero, size: contentSize)).size

		var frame = window.frame
		frame.origin.y += frame.height - newWindowSize.height
		frame.size = newWindowSize
		window.animator().setFrame(frame, display: false)
	}

	override func transition(from fromViewController: NSViewController, to toViewController: NSViewController, options: NSViewController.TransitionOptions = [], completionHandler completion: (() -> Void)? = nil) {
		
		NSAnimationContext.runAnimationGroup({ context in
			context.duration = 0.5
			setWindowFrame(for: toViewController)
			super.transition(from: fromViewController, to: toViewController, options: [.crossfade, .allowUserInteraction], completionHandler: completion)
		}, completionHandler: nil)
	}

	internal func configure(preferences: [Preferenceable], style: PreferencesStyle) {
		tabViewItems = preferences.map { preference in
			let item = NSTabViewItem(identifier: preference.toolbarItemTitle)
			item.label = preference.toolbarItemTitle
			if style == .tabs {
				item.image = preference.toolbarItemIcon
			}
			item.viewController = preference.viewController
			return item
		}

		tabViewSizes = preferences.map { preference -> (String, CGSize) in
			return (preference.viewController.simpleClassName,
					preference.viewController.view.frame.size)
		}

		tabStyle = style.tabStyle
		transitionOptions = [.crossfade, .slideDown]
	}
}

extension Collection {
	func map<T, U>(_ transform: (Element) throws -> (key: T, value: U)) rethrows -> [T: U] {
		var result: [T: U] = [:]
		for element in self {
			let transformation = try transform(element)
			result[transformation.key] = transformation.value
		}
		return result
	}
}
