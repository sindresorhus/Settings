import SwiftUI

@available(macOS 10.15, *)
extension Preferences {
	/**
	Function builder for `Preferences` components used in order to restrict types of child views to be of type `Section`.
	*/
	@_functionBuilder
	public struct SectionBuilder {
		public static func buildBlock(_ sections: Section...) -> [Section] {
			sections
		}
	}

	/**
	A view which holds `Preferences.Section` views and does all the alignment magic similar to `NSGridView` from AppKit.
	*/
	public struct Container: View {
		private let sectionBuilder: () -> [Section]
		private let contentWidth: Double
		@State private var maxLabelWidth: CGFloat = 0.0

		/**
		Creates an instance of container component, which handles layout of stacked `Preferences.Section` views.

		Custom alignment requires content width to be specified beforehand.

		- Parameters:
			- contentWidth: A fixed width of the container's content (excluding paddings).
			- builder: A view builder that creates `Preferences.Section`'s of this container.
		*/
		public init(
			contentWidth: Double,
			@SectionBuilder builder: @escaping () -> [Section]
		) {
			self.sectionBuilder = builder
			self.contentWidth = contentWidth
		}

		public var body: some View {
			let sections = sectionBuilder()

			return VStack(alignment: .preferenceSectionLabel) {
				ForEach(0..<sections.count, id: \.self) { index in
					self.viewForSection(sections, index: index)
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
