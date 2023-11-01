/**
The namespace for this package.
*/
public enum Settings {}

/**
A typealias for this package's namespace to solve the conflict with [SwiftUI.Settings](https://developer.apple.com/documentation/swiftui/settings)

You can also use the following code snippet to solve the conflict
```swift
import enum Settings.Settings
```
 */
public typealias AppSettings = Settings

// TODO: Remove in the next major version.
// Preserve backwards compatibility.
@available(*, deprecated, renamed: "Settings")
public typealias Preferences = Settings
@available(*, deprecated, renamed: "SettingsPane")
public typealias PreferencePane = SettingsPane
@available(*, deprecated, renamed: "SettingsPaneConvertible")
public typealias PreferencePaneConvertible = SettingsPaneConvertible
@available(*, deprecated, renamed: "SettingsWindowController")
public typealias PreferencesWindowController = SettingsWindowController

@available(macOS 10.15, *)
extension Settings.Pane {
	@available(*, deprecated, renamed: "asSettingsPane()")
	public func asPreferencePane() -> PreferencePane {
		asSettingsPane()
	}
}

extension SettingsWindowController {
	@available(*, deprecated, renamed: "init(panes:style:animated:hidesToolbarForSingleItem:)")
	public convenience init(
		preferencePanes: [PreferencePane],
		style: Settings.Style = .toolbarItems,
		animated: Bool = true,
		hidesToolbarForSingleItem: Bool = true
	) {
		self.init(
			panes: preferencePanes,
			style: style,
			animated: animated,
			hidesToolbarForSingleItem: hidesToolbarForSingleItem)
	}
}
