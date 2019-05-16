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
			"en_AU": "Preferences",
			"en_GB": "Preferences",
			"es": "Preferencias",
			"es_419": "Preferencias",
			"fi": "Asetukset",
			"fr": "Préférences",
			"fr_CA": "Préférences",
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
			"pt_PT": "Preferências",
			"ro": "Preferințe",
			"ru": "Настройки",
			"sk": "Nastavenia",
			"sv": "Inställningar",
			"th": "การตั้งค่า",
			"tr": "Tercihler",
			"uk": "Параметри",
			"vi": "Tùy chọn",
			"zh_CN": "偏好设置",
			"zh_HK": "偏好設定",
			"zh_TW": "偏好設定"
		],
		.preferencesEllipsized: [
			"ar": "تفضيلات…",
			"ca": "Preferències…",
			"cs": "Předvolby…",
			"da": "Indstillinger…",
			"de": "Einstellungen…",
			"el": "Προτιμήσεις…",
			"en": "Preferences…",
			"en_AU": "Preferences…",
			"en_GB": "Preferences…",
			"es": "Preferencias…",
			"es_419": "Preferencias…",
			"fi": "Asetukset…",
			"fr": "Préférences…",
			"fr_CA": "Préférences…",
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
			"pt_PT": "Preferências…",
			"ro": "Preferințe…",
			"ru": "Настройки…",
			"sk": "Nastavenia…",
			"sv": "Inställningar…",
			"th": "การตั้งค่า…",
			"tr": "Tercihler…",
			"uk": "Параметри…",
			"vi": "Tùy chọn…",
			"zh_CN": "偏好设置…",
			"zh_HK": "偏好設定⋯",
			"zh_TW": "偏好設定⋯"
		]
	]

	// TODO: Use a static subscript instead of a `get` method when using Swift 5.1
	/// Returns the localized version of the specified string.
	///
	/// - Note: If the system's locale can't be determined, the English localization of the string will be returned.
	/// - Parameter identifier: Identifier of the string to localize.
	static func get(identifier: Identifier) -> String {
		let locale = Locale.current

		// force-unwrapped since 100% of the involved code is under our control
		let localizedDict = Localization.localizedStrings[identifier]!

		guard let languageCode = locale.languageCode, let regionCode = locale.regionCode else {
			// Fall back to English locale, which always exists
			return localizedDict["en"]!
		}

		let localeIdentifier = "\(languageCode)_\(regionCode)"

		if let localizedString = localizedDict[localeIdentifier] {
			return localizedString
		}

		if let localizedString = localizedDict[languageCode] {
			return localizedString
		}

		// Fall back to English locale, which always exists
		return localizedDict["en"]!
	}
}
