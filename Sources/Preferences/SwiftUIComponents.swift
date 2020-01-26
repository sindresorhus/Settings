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
@available (macOS 10.15, *)
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
@available (macOS 10.15, *)
@_functionBuilder
public struct SectionBuilder {
	public static func buildBlock(_ sections: PreferenceSection...) -> [PreferenceSection] {
		return sections
	}
}

/**
	Represents section with left aligned title and optional bottom divider (present by default).
 */
@available (macOS 10.15, *)
public struct PreferenceSection: View   {
	public let title: String
	public let content: () -> AnyView
	public let bottomDivider: Bool

	public init<Content: View>(title: String, bottomDivider: Bool = true, content: @escaping () -> Content) {
		self.title = title
		self.bottomDivider = bottomDivider
		self.content = { AnyView(content()) }
	}

	public var body: some View {
		HStack(alignment: .top) {
			Text(title)
				.font(.system(size: fontSize))
				.alignmentGuide(.preferenceSectionLabel, computeValue: { $0[.trailing] })
			content()
			Spacer()
		}
	}
	
	var fontSize: CGFloat {
		return 13.0
	}

	var labelWidth: CGFloat {
		// Don't see any other possibility to obtain Text width...
		let attr = [
			NSAttributedString.Key.font: NSFont.systemFont(ofSize: fontSize)
		]
		let attrString = NSAttributedString(string: title, attributes: attr)
		let textField = NSTextField(labelWithAttributedString: attrString)
		let size = textField.intrinsicContentSize
		return size.width
	}
}

/**
	Container for PreferenceSection objects.
 */
@available (macOS 10.15, *)
public struct Preferences: View {
	public let sectionBuilder: () -> [PreferenceSection]
	public let contentWidth: CGFloat

	public init(contentWidth: CGFloat, @SectionBuilder builder: @escaping () -> [PreferenceSection]) {
		self.sectionBuilder = builder
		self.contentWidth = contentWidth
	}

	public var body: some View {
		let sections = sectionBuilder()
		let maxLabelWidth =
			sections
				.map { $0.labelWidth }
				.max()!
		
		return VStack(alignment: .preferenceSectionLabel) {
			ForEach(0..<sections.count, id: \.self) { i in
				self.viewForSection(sections, index: i, maxLabelWidth: maxLabelWidth)
			}
		}
		.frame(width: contentWidth, alignment: .leading)
		.padding([.top, .bottom], 20.0)
		.padding([.leading, .trailing], 30.0)
	}

	private func viewForSection(_ sections: [PreferenceSection], index: Int, maxLabelWidth: CGFloat) -> AnyView{
		if index != sections.count - 1 && sections[index].bottomDivider {
			return
				Group {
					sections[index]
					Divider()
						// Strangely doesn't work without width specification, probably bc of custom alignment
						.frame(width: contentWidth, height: 20.0)
						.alignmentGuide(.preferenceSectionLabel, computeValue: { d in d[.leading] + maxLabelWidth })
				}
				.eraseToAnyView()
		} else {
			return sections[index]
				.eraseToAnyView()
		}
	}
}

@available (macOS 10.15, *)
extension View {
	func eraseToAnyView() -> AnyView {
		return AnyView(self)
	}
}
