//
//  PreferenceSection.swift
//  Preferences
//
//  Created by Kacper on 19/02/2020.
//

import SwiftUI

@available(macOS 10.15, *)
extension Preferences {
	/**
	Applies font and color for labels used for describing preferences
	*/
	@available(macOS 10.15, *)
	public struct PreferenceDescriptionModifier: ViewModifier {
		public func body(content: Content) -> some View {
			content
				.font(Font.system(size: 11.0))
				.foregroundColor(.secondary)
		}
	}

	/**
	Represents section with left aligned title and optional bottom divider (present by default).
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
		Convenience overlay for finding label's dimensions using GeometryReader.
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
		Convenience modifier for applying LabelWidthPreferenceKey.
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
		Creates instance of section, responsible for controling single preference.
		
		- Parameters:
			- bottomDivider: Pass `true`, to place `Divider` after section content. Default is `false`.
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
			- bottomDivider: Pass `true`, to place `Divider` after section content. Default is `false`.
			- content: A content view.
		*/
		public init<Content: View>(title: String, bottomDivider: Bool = false, @ViewBuilder content: @escaping () -> Content) {
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

@available(macOS 10.15, *)
extension View {
	/**
	Applies font and color for labels used for describing preferences using PreferenceDescriptionModifier
	*/
	public func preferenceDescription() -> some View {
		self.modifier(Preferences.PreferenceDescriptionModifier())
	}

	/**
	Equivalent to `eraseToAnyPublisher` from Combine framework
	*/
	func eraseToAnyView() -> AnyView {
		AnyView(self)
	}
}
