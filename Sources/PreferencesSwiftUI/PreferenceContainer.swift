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
	Container for PreferenceSection objects.
 */
@available(macOS 10.15, *)
public struct PreferenceContainer: View {
	public let sectionBuilder: () -> [PreferenceSection]
	public let contentWidth: Double
	@State private var maxLabelWidth: CGFloat = 0.0

	public init(contentWidth: Double, @PreferenceSectionBuilder builder: @escaping () -> [PreferenceSection]) {
		self.sectionBuilder = builder
		self.contentWidth = contentWidth
	}

	public var body: some View {
		let sections = sectionBuilder()
		return VStack(alignment: .preferenceSectionLabel) {
			ForEach(0..<sections.count, id: \.self) { idx in
				self.viewForSection(sections, index: idx)
			}
		}
		.modifier(PreferenceSection.LabelWidthModifier(maxWidth: $maxLabelWidth))
		.frame(width: CGFloat(contentWidth), alignment: .leading)
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
						.frame(width: CGFloat(contentWidth), height: 20.0)
						.alignmentGuide(.preferenceSectionLabel) { dim in dim[.leading] + self.maxLabelWidth }
				}
			} else {
				sections[index]
			}
		}
	}
}
