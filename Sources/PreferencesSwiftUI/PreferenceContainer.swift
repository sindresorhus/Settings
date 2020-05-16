//
//  SwiftUIComponents.swift
//  Preferences
//
//  Created by Kacper on 09/01/2020.
//

import SwiftUI

@available(macOS 10.15, *)
extension Preferences {
	/**
	Function builder for Preferences component used in order to restrict types of child view to Section.
	*/
	@_functionBuilder
	public struct SectionBuilder {
		public static func buildBlock(_ sections: Section...) -> [Section] {
			sections
		}
	}

	/**
	Container for Section objects.
	*/
	public struct Container: View {
		public let sectionBuilder: () -> [Section]
		public let contentWidth: Double
		@State private var maxLabelWidth: CGFloat = 0.0

		public init(contentWidth: Double, @SectionBuilder builder: @escaping () -> [Section]) {
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
			.modifier(Section.LabelWidthModifier(maxWidth: $maxLabelWidth))
			.frame(width: CGFloat(contentWidth), alignment: .leading)
			.padding(.vertical, 20.0)
			.padding(.horizontal, 30.0)
		}

		private func viewForSection(_ sections: [Section], index: Int) -> some View {
			Group {
				if index != sections.count - 1 && sections[index].bottomDivider {
					Group {
						sections[index]
						Divider()
							// Strangely doesn't work without width being specified. Probably because of custom alignment.
							.frame(width: CGFloat(contentWidth), height: 20.0)
							.alignmentGuide(.preferenceSectionLabel) { $0[.leading] + self.maxLabelWidth }
					}
				} else {
					sections[index]
				}
			}
		}
	}
}

/**
Extension with custom alignment guide for section title labels.
*/
@available(macOS 10.15, *)
extension HorizontalAlignment {
	private enum PreferenceSectionLabelAlignment: AlignmentID {
		static func defaultValue(in context: ViewDimensions) -> CGFloat {
			context[HorizontalAlignment.leading]
		}
	}

	static let preferenceSectionLabel = HorizontalAlignment(PreferenceSectionLabelAlignment.self)
}
