import Foundation

struct Localization {
	enum Identifier {
		case preferences
		case settings
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
			"en-AU": "Preferences",
			"en-GB": "Preferences",
			"es": "Preferencias",
			"es-419": "Preferencias",
			"fi": "Asetukset",
			"fr": "Préférences",
			"fr-CA": "Préférences",
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
			"pt-PT": "Preferências",
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
		.settings: [
			"ar": "الإعدادات",
			"ca": "Configuració",
			"cs": "Nastavení",
			"da": "Indstillinger",
			"de": "Einstellungen",
			"el": "Ρυθμίσεις",
			"en": "Settings",
			"en-AU": "Settings",
			"en-GB": "Settings",
			"es": "Ajustes",
			"es-419": "Ajustes",
			"fi": "Asetukset",
			"fr": "Réglages",
			"fr-CA": "Réglages",
			"he": "הגדרות",
			"hi": "समायोजन",
			"hr": "Postavke",
			"hu": "Beállítások",
			"id": "Pengaturan",
			"it": "Impostazioni",
			"ja": "設定",
			"ko": "설정",
			"ms": "Tetapan",
			"nl": "Instellingen",
			"no": "Innstillinger",
			"pl": "Ustawienia",
			"pt": "Ajustes",
			"pt-PT": "Definições",
			"ro": "Configurări",
			"ru": "Настройки",
			"sk": "Nastavenia",
			"sv": "Inställningar",
			"th": "ค่าติดตั้ง",
			"tr": "Ayarlar",
			"uk": "Параметри",
			"vi": "Cài đặt",
			"zh-CN": "设置",
			"zh-HK": "設定",
			"zh-TW": "設定"
		]
	]

	/**
	Returns the localized version of the given string.

	- Parameter identifier: Identifier of the string to localize.

	- Note: If the system's locale can't be determined, the English localization of the string will be returned.
	*/
	static subscript(identifier: Identifier) -> String {
		// Force-unwrapped since all of the involved code is under our control.
		let localizedDict = Localization.localizedStrings[identifier]!
		let defaultLocalizedString = localizedDict["en"]!

		// Iterate through all user-preferred languages until we find one that has a valid language code.
		let preferredLocale = Locale.preferredLanguages
			// TODO: Use `.firstNonNil()` here when available.
			.lazy
			.map { Locale(identifier: $0) }
			.first { $0.languageCode != nil }
			?? .current

		guard let languageCode = preferredLocale.languageCode else {
			return defaultLocalizedString
		}

		// Chinese is the only language where different region codes result in different translations.
		if languageCode == "zh" {
			let regionCode = preferredLocale.regionCode ?? ""
			if regionCode == "HK" || regionCode == "TW" {
				return localizedDict["\(languageCode)-\(regionCode)"]!
			} else {
				// Fall back to "regular" zh-CN if neither the HK or TW region codes are found.
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
