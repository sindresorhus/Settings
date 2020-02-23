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
let UserAccountsPreferenceViewController: () -> PreferencePane = {
	PreferencePaneHostingController(preferencePaneView: UserAccountsView())
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
struct UserAccountsView: View, PreferencePaneView {
	@State private var isOn1 = true
	@State private var isOn2 = false
	@State private var isOn3 = true
	@State private var selection1 = 1
	@State private var selection2 = 0
	let contentWidth: CGFloat = 450.0
	let preferencePaneIdentifier = PreferencePaneIdentifier.userAccounts
	let preferencePaneTitle = "User Accounts"
	let toolbarItemIcon = NSImage(named: NSImage.userAccountsName)!

	var body: some View {
		PreferenceContainer(contentWidth: contentWidth) {
			PreferenceSection(title: "Permissions:") {
				VStack(alignment: .leading) {
					Toggle("Allow user to administer this computer", isOn: self.$isOn1)
					Text("Administrator has root access to this machine.")
						.font(.preferenceDescription)
						.foregroundColor(.secondary)
					Toggle("Allow user to access every file", isOn: self.$isOn2)
				}
			}
			PreferenceSection(title: "Show scroll bars:") {
				Picker(selection: self.$selection1, label: EmptyView()) {
					Text("When scrolling").tag(0)
					Text("Always").tag(1)
				}
					.pickerStyle(RadioGroupPickerStyle())
			}
			PreferenceSection(label: {
				Toggle("Some toggle", isOn: self.$isOn3)
			}) {
				VStack(alignment: .leading) {
					Picker(selection: self.$selection2, label: EmptyView()) {
						Text("Automatic").tag(0)
						Text("Manual").tag(1)
					}.frame(width: 120.0)
					Text("Automatic mode can slow things down.")
						.font(.preferenceDescription)
						.foregroundColor(.secondary)
				}
			}
			PreferenceSection(title: "Preview mode:") {
				VStack(alignment: .leading) {
					Picker(selection: self.$selection2, label: EmptyView()) {
						Text("Automatic").tag(0)
						Text("Manual").tag(1)
					}.frame(width: 120.0)
					Text("Automatic mode can slow things down.")
						.font(.preferenceDescription)
						.foregroundColor(.secondary)
				}
			}
		}
	}
}

struct UserAccountsView_Previews: PreviewProvider {
	static var previews: some View {
		UserAccountsView()
	}
}
