//
//  UserAccountsView.swift
//  Preferences
//
//  Created by Kacper on 06/01/2020.
//

import SwiftUI
import Preferences

/**
Function wrapping SwiftUI into `PreferencePane`, which is mimicking view controller's default construction syntax.
*/
let UserAccountsPreferenceViewController: () -> PreferencePane = {
	/// Wrap your custom view into `Preferences.PaneView`, while providing necessary toolbar info.
	let paneView =
		Preferences.PaneView(
			identifier: .userAccounts,
			title: "User Accounts",
			toolbarIcon: NSImage(named: NSImage.userAccountsName)!
		) {
			UserAccountsView()
		}
	return Preferences.PaneHostingController(paneView: paneView)
}

/**
The main view of “User Accounts” preference pane.
*/
struct UserAccountsView: View {
	@State private var isOn1 = true
	@State private var isOn2 = false
	@State private var isOn3 = true
	@State private var selection1 = 1
	@State private var selection2 = 0
	@State private var selection3 = 0
	let contentWidth: Double = 450.0

	var body: some View {
		Preferences.Container(contentWidth: contentWidth) {
			Preferences.Section(title: "Permissions:") {
				Toggle("Allow user to administer this computer", isOn: self.$isOn1)
				Text("Administrator has root access to this machine.")
					.preferenceDescription()
				Toggle("Allow user to access every file", isOn: self.$isOn2)
			}
			Preferences.Section(title: "Show scroll bars:") {
				Picker("", selection: self.$selection1) {
					Text("When scrolling").tag(0)
					Text("Always").tag(1)
				}
					.labelsHidden()
					.pickerStyle(RadioGroupPickerStyle())
			}
			Preferences.Section(label: {
				Toggle("Some toggle", isOn: self.$isOn3)
			}) {
				Picker("", selection: self.$selection2) {
					Text("Automatic").tag(0)
					Text("Manual").tag(1)
				}
					.labelsHidden()
					.frame(width: 120.0)
				Text("Automatic mode can slow things down.")
					.preferenceDescription()
			}
			Preferences.Section(title: "Preview mode:") {
				Picker("", selection: self.$selection3) {
					Text("Automatic").tag(0)
					Text("Manual").tag(1)
				}
					.labelsHidden()
					.frame(width: 120.0)
				Text("Automatic mode can slow things down.")
					.preferenceDescription()
			}
		}
	}
}

struct UserAccountsView_Previews: PreviewProvider {
	static var previews: some View {
		UserAccountsView()
	}
}
