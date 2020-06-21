import SwiftUI

@available(macOS 10.15, *)
extension Preferences {
	/**
	Represents a section with right-aligned title and optional bottom divider.
	*/
	@available(macOS 10.15, *)
	public struct Section: View {
		/**
		Preference key holding max width of section labels.
		*/
		private struct LabelWidthPreferenceKey: PreferenceKey {
			typealias Value = CGFloat

			static var defaultValue: CGFloat = 0.0

			static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
				let next = nextValue()
				value = next > value ? next : value
			}
		}

		/**
		Convenience overlay for finding a label's dimensions using `GeometryReader`.
		*/
		private struct LabelOverlay: View {
			var body: some View {
				GeometryReader { geometry in
					Rectangle()
						.fill(Color.clear)
						.preference(key: LabelWidthPreferenceKey.self, value: geometry.size.width)
				}
			}
		}

		/**
		Convenience modifier for applying `LabelWidthPreferenceKey`.
		*/
		struct LabelWidthModifier: ViewModifier {
			@Binding var maxWidth: CGFloat

			func body(content: Content) -> some View {
				content
					.onPreferenceChange(LabelWidthPreferenceKey.self) { maxWidth in
						self.maxWidth = maxWidth
					}
			}
		}

		public let label: AnyView
		public let content: AnyView
		public let bottomDivider: Bool

		/**
		A section is responsible for controlling a single preference.

		- Parameters:
			- bottomDivider: Whether to place a `Divider` after the section content. Default is `false`.
			- label: A view describing preference handled by this section.
			- content: A content view.
		*/
		public init<Label: View, Content: View>(
			bottomDivider: Bool = false,
			label: @escaping () -> Label,
			@ViewBuilder content: @escaping () -> Content
		) {
			self.label = label()
				.overlay(LabelOverlay())
				.eraseToAnyView()
			self.bottomDivider = bottomDivider
			let stack = VStack(alignment: .leading) { content() }
			self.content = stack.eraseToAnyView()
		}

		/**
		Creates instance of section, responsible for controling single preference with `Text` as  a `Label`.

		- Parameters:
			- title: A string describing preference handled by this section.
			- bottomDivider: Whether to place a `Divider` after the section content. Default is `false`.
			- content: A content view.
		*/
		public init<Content: View>(
			title: String,
			bottomDivider: Bool = false,
			@ViewBuilder content: @escaping () -> Content
		) {
			let textLabel = {
				Text(title)
					.font(.system(size: 13.0))
					.overlay(LabelOverlay())
					.eraseToAnyView()
			}

			self.init(bottomDivider: bottomDivider, label: textLabel, content: content)
		}

		public var body: some View {
			HStack(alignment: .top) {
				label
					.alignmentGuide(.preferenceSectionLabel) { $0[.trailing] }
				content
				Spacer()
			}
		}
	}
}
