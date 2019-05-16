import Foundation

public enum LocalizationIdentifier {
	case preferences
	case preferencesEllipsized
}

struct Localization {
	private static let localizedStrings: [LocalizationIdentifier: [String: String]] = [
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

	static func get(identifier: LocalizationIdentifier) -> String {
		let locale = Locale.current
		if let languageCode = locale.languageCode, let regionCode = locale.regionCode, let localizedDict = Localization.localizedStrings[identifier] {
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

		// Fall back that shouldn't ever happen
		return "PREFERENCES"
	}
}
