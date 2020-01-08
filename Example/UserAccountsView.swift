//
//  UserAccountsView.swift
//  Preferences
//
//  Created by Kacper on 06/01/2020.
//

import SwiftUI
import Preferences

/**
	Function wrapping SwiftUI into PreferencePane, which is mimicing view controller's default construction syntax
 */
func UserAccountsPreferenceViewController() -> PreferencePane {
	let icon = NSImage(named: NSImage.userAccountsName)!
	return PreferencePaneHostingController(identifier: .userAccounts,
										   title: "User Accounts",
										   toolbarIcon: icon,
										   content: UserAccountsView())
}

/**
	Extension with custom alignment guide for section title labels
 */
extension HorizontalAlignment {
	private enum PreferenceSectionLabelAlignment: AlignmentID {
		static func defaultValue(in context: ViewDimensions) -> CGFloat {
			return context[HorizontalAlignment.leading]
		}
	}
    
	static let preferenceSectionLabel = HorizontalAlignment(PreferenceSectionLabelAlignment.self)
}

/**
	Default fonts for preferences
 */
extension Font {
	static var preferenceDescription: Font {
		return Font.system(size: 11.0)
	}
}

/**
	Main view of User Accounts preference screen
 */
struct UserAccountsView: View {
	@State private var isOn1 = true
	@State private var isOn2 = false
	@State private var selection1 = 1
	@State private var selection2 = 0
	let width: CGFloat = 510.0
        
	var body: some View {
		VStack(alignment: .preferenceSectionLabel) {
			CheckboxSectionView(isOn1: $isOn1, isOn2: $isOn2)
			Divider()
				.frame(width: width, height: 20.0)
				.alignmentGuide(.preferenceSectionLabel, computeValue: { $0[.leading] + 104.0 })
			RadioSectionView(selection: $selection1)
			Divider()
				.frame(width: width, height: 20.0)
				.alignmentGuide(.preferenceSectionLabel, computeValue: { $0[.leading] + 104.0 })
			PickerSectionView(selection: $selection2)
		}
		.frame(width: width, alignment: .leading)
		.padding([.top, .bottom], 20.0)
		.padding([.leading, .trailing], 30.0)
	}
}

// Some example sections with various input methods
struct RadioSectionView: View {
	@Binding var selection: Int
    
	var body: some View {
		HStack(alignment: .top) {
			Text("Show scroll bars:")
				.alignmentGuide(.preferenceSectionLabel, computeValue: { $0[.trailing] })
			Picker(selection: $selection, label: EmptyView()) {
				Text("When scrolling").tag(0)
				Text("Always").tag(1)
			}
				.pickerStyle(RadioGroupPickerStyle())
			Spacer()
		}
	}
}

struct CheckboxSectionView: View {
	@Binding var isOn1: Bool
	@Binding var isOn2: Bool
    
	var body: some View {
		HStack(alignment: .top) {
			Text("Permissions:")
				.alignmentGuide(.preferenceSectionLabel, computeValue: { $0[.trailing] })
			VStack(alignment: .leading) {
				Toggle("Allow user to administer this computer", isOn: $isOn1)
				Text("Administrator has root access to this machine.")
					.font(.preferenceDescription)
					.foregroundColor(.secondary)
				Toggle("Allow user to access every file", isOn: $isOn2)
			}
			Spacer()
		}
	}
}
 
struct PickerSectionView: View {
	@Binding var selection: Int
    
	var body: some View {
		HStack(alignment: .top) {
			Text("Preview mode:")
				.alignmentGuide(.preferenceSectionLabel, computeValue: { $0[.trailing] })
			VStack(alignment: .leading) {
				Picker(selection: $selection, label: EmptyView()) {
					Text("Automatic").tag(0)
					Text("Manual").tag(1)
				}.frame(width: 120.0)
				Text("Automatic mode can slow things down.")
					.font(.preferenceDescription)
					.foregroundColor(.secondary)
			}
			Spacer()
		}
	}
}

struct UserAccountsView_Previews: PreviewProvider {
	static var previews: some View {
		UserAccountsView()
	}
}
