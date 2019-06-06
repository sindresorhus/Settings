import Foundation

struct Localization {
	enum Identifier {
		case preferences
		case preferencesEllipsized
	}

	private static let localizedStrings: [Identifier: [String: String]] = [
		.preferences: [
			"ar": "تفضيلات",
			"ca": "Preferències",
			"cs": "Předvolby",
			"da": "Indstillinger",
			"de": "Einstellungen",
			"el": "Προτιμήσεις",
			"en": "Preferences",
			"es": "Preferencias",
			"fi": "Asetukset",
			"fr": "Préférences",
			"he": "העדפות",
			"hi": "प्राथमिकता",
			"hr": "Postavke",
			"hu": "Beállítások",
			"id": "Preferensi",
			"it": "Preferenze",
			"ja": "環境設定",
			"ko": "환경설정",
			"ms": "Keutamaan",
			"nl": "Voorkeuren",
			"no": "Valg",
			"pl": "Preferencje",
			"pt": "Preferências",
			"ro": "Preferințe",
			"ru": "Настройки",
			"sk": "Nastavenia",
			"sv": "Inställningar",
			"th": "การตั้งค่า",
			"tr": "Tercihler",
			"uk": "Параметри",
			"vi": "Tùy chọn",
			"zh-CN": "偏好设置",
			"zh-HK": "偏好設定",
			"zh-TW": "偏好設定"
		],
		.preferencesEllipsized: [
			"ar": "تفضيلات…",
			"ca": "Preferències…",
			"cs": "Předvolby…",
			"da": "Indstillinger…",
			"de": "Einstellungen…",
			"el": "Προτιμήσεις…",
			"en": "Preferences…",
			"es": "Preferencias…",
			"fi": "Asetukset…",
			"fr": "Préférences…",
			"he": "העדפות…",
			"hi": "प्राथमिकता…",
			"hr": "Postavke…",
			"hu": "Beállítások…",
			"id": "Preferensi…",
			"it": "Preferenze…",
			"ja": "環境設定…",
			"ko": "환경설정...",
			"ms": "Keutamaan…",
			"nl": "Voorkeuren…",
			"no": "Valg…",
			"pl": "Preferencje…",
			"pt": "Preferências…",
			"ro": "Preferințe…",
			"ru": "Настройки…",
			"sk": "Nastavenia…",
			"sv": "Inställningar…",
			"th": "การตั้งค่า…",
			"tr": "Tercihler…",
			"uk": "Параметри…",
			"vi": "Tùy chọn…",
			"zh-CN": "偏好设置…",
			"zh-HK": "偏好設定⋯",
			"zh-TW": "偏好設定⋯"
		]
	]

	// TODO: Use a static subscript instead of a `get` method when using Swift 5.1
	/**
	Returns the localized version of the given string.

	- Note: If the system's locale can't be determined, the English localization of the string will be returned.
	- Parameter identifier: Identifier of the string to localize.
	*/
	static func get(identifier: Identifier) -> String {
		// Force-unwrapped since all of the involved code is under our control.
		let localizedDict = Localization.localizedStrings[identifier]!
		let defaultLocalizedString = localizedDict["en"]!

		// Iterate through all user-preferred languages until we find one that has a valid language code
		var preferredLocale = Locale.current
		for localeID in Locale.preferredLanguages {
			let locale = Locale(identifier: localeID)
			if locale.languageCode != nil {
				preferredLocale = locale
				break
			}
		}

		guard let languageCode = preferredLocale.languageCode else {
			return defaultLocalizedString
		}

		// Chinese is the only language where different region codes result in different translations
		if languageCode == "zh" {
			let regionCode = preferredLocale.regionCode ?? ""
			if regionCode == "HK" || regionCode == "TW" {
				return localizedDict["\(languageCode)-\(regionCode)"]!
			} else {
				// Fall back to "regular" zh-CN if neither the HK or TW region codes are found
				return localizedDict["\(languageCode)-CN"]!
			}
		} else {
			if let localizedString = localizedDict[languageCode] {
				return localizedString
			}
		}

		return defaultLocalizedString
	}
}
