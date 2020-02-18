//
//  SwiftUIComponents.swift
//  Preferences
//
//  Created by Kacper on 09/01/2020.
//

import SwiftUI

/**
	Extension with custom alignment guide for section title labels.
 */
@available(macOS 10.15, *)
extension HorizontalAlignment {
	private enum PreferenceSectionLabelAlignment: AlignmentID {
		static func defaultValue(in context: ViewDimensions) -> CGFloat {
			return context[HorizontalAlignment.leading]
		}
	}

	static let preferenceSectionLabel = HorizontalAlignment(PreferenceSectionLabelAlignment.self)
}

/**
	Function builder for Preferences component used in order to restrict types of child view to PreferenceSection.
*/
@available(macOS 10.15, *)
@_functionBuilder
public struct PreferenceSectionBuilder {
	public static func buildBlock(_ sections: PreferenceSection...) -> [PreferenceSection] {
		return sections
	}
}

/**
	Represents section with left aligned title and optional bottom divider (present by default).
 */
@available(macOS 10.15, *)
public struct PreferenceSection: View   {
	struct LabelWidthPreferenceKey: PreferenceKey {
		typealias Value = CGFloat
		
		static var defaultValue: CGFloat = 0.0
		
		static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
			let next = nextValue()
			value = next > value ? next : value
		}
	}
	
	struct LabelOverlay: View {
		var body: some View {
			GeometryReader { geometry in
				Rectangle()
					.fill(Color.clear)
					.preference(key: LabelWidthPreferenceKey.self, value: geometry.size.width)
			}
		}
	}
	
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
	
	public init<Label: View, Content: View>(bottomDivider: Bool = false,
											label: @escaping () -> Label,
											content: @escaping () -> Content) {
		self.label = label()
			.overlay(LabelOverlay())
			.eraseToAnyView()
		self.bottomDivider = bottomDivider
		self.content = content().eraseToAnyView()
	}
	
	public init<Content: View>(title: String, bottomDivider: Bool = true, content: @escaping () -> Content) {
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
				.alignmentGuide(.preferenceSectionLabel, computeValue: { $0[.trailing] })
			content
			Spacer()
		}
	}
}

/**
	Container for PreferenceSection objects.
 */
@available(macOS 10.15, *)
public struct Preferences: View {
	public let sectionBuilder: () -> [PreferenceSection]
	public let contentWidth: CGFloat
	@State var maxLabelWidth: CGFloat = 0.0

	public init(contentWidth: CGFloat, @PreferenceSectionBuilder builder: @escaping () -> [PreferenceSection]) {
		self.sectionBuilder = builder
		self.contentWidth = contentWidth
	}

	public var body: some View {
		let sections = sectionBuilder()
		return VStack(alignment: .preferenceSectionLabel) {
			ForEach(0..<sections.count, id: \.self) { i in
				self.viewForSection(sections, index: i)
			}
		}
		.modifier(PreferenceSection.LabelWidthModifier(maxWidth: $maxLabelWidth))
		.frame(width: contentWidth, alignment: .leading)
		.padding(.vertical, 20.0)
		.padding(.horizontal, 30.0)
	}

	private func viewForSection(_ sections: [PreferenceSection], index: Int) -> some View {
		return Group {
			if index != sections.count - 1 && sections[index].bottomDivider {
				Group {
					sections[index]
					Divider()
						// Strangely doesn't work without width specification, probably bc of custom alignment
						.frame(width: contentWidth, height: 20.0)
						.alignmentGuide(.preferenceSectionLabel, computeValue: { d in d[.leading] + self.maxLabelWidth })
				}
			} else {
				sections[index]
			}
		}
	}
}

@available(macOS 10.15, *)
extension View {
	func eraseToAnyView() -> AnyView {
		return AnyView(self)
	}
}
