import SwiftUI
import Preferences

/**
Function wrapping SwiftUI into `SettingsPane`, which is mimicking view controller's default construction syntax.
*/
let AccountsSettingsViewController: () -> SettingsPane = { // swiftlint:disable:this identifier_name
	/**
	Wrap your custom view into `Settings.Pane`, while providing necessary toolbar info.
	*/
	let paneView = Settings.Pane(
		identifier: .accounts,
		title: "Accounts",
		toolbarIcon: NSImage(systemSymbolName: "person.crop.circle", accessibilityDescription: "Accounts settings")!
	) {
		AccountsScreen()
	}

	return Settings.PaneHostingController(pane: paneView)
}

/**
The main view of “Accounts” settings pane.
*/
struct AccountsScreen: View {
	@State private var isOn1 = true
	@State private var isOn2 = false
	@State private var isOn3 = true
	@State private var selection1 = 1
	@State private var selection2 = 0
	@State private var selection3 = 0
	@State private var isExpanded = false
	private let contentWidth: Double = 450.0

	var body: some View {
		Settings.Container(contentWidth: contentWidth) {
			Settings.Section(title: "Permissions:") {
				Toggle("Allow user to administer this computer", isOn: $isOn1)
				Text("Administrator has root access to this machine.")
					.preferenceDescription()
				Toggle("Allow user to access every file", isOn: $isOn2)
			}
			Settings.Section(title: "Show scroll bars:") {
				Picker("", selection: $selection1) {
					Text("When scrolling").tag(0)
					Text("Always").tag(1)
				}
					.labelsHidden()
					.pickerStyle(.radioGroup)
			}
			Settings.Section(label: {
				Toggle("Some toggle", isOn: $isOn3)
			}) {
				Picker("", selection: $selection2) {
					Text("Automatic").tag(0)
					Text("Manual").tag(1)
				}
					.labelsHidden()
					.frame(width: 120.0)
				Text("Automatic mode can slow things down.")
					.preferenceDescription()
			}
			Settings.Section(title: "Preview mode:") {
				Picker("", selection: $selection3) {
					Text("Automatic").tag(0)
					Text("Manual").tag(1)
				}
					.labelsHidden()
					.frame(width: 120.0)
				Text("Automatic mode can slow things down.")
					.preferenceDescription()
			}
			Settings.Section(title: "Expand this pane:") {
				Toggle("Expand", isOn: $expand)
				if isExpanded {
					ZStack(alignment: .center) {
						Rectangle()
							.fill(.gray)
							.frame(width: 200, height: 200)
							.cornerRadius(20)
						Text("It would be nice if the window would animate based on the size of the content :)")
							.frame(width: 180, height: 180)
							.multilineTextAlignment(.center)
							.colorInvert()
					}
				}
			}
		}
	}
}

struct AccountsScreen_Previews: PreviewProvider {
	static var previews: some View {
		AccountsScreen()
	}
}
