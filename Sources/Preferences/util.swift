import Cocoa

class System {
	private static let preferencesLocalized: [String: String] = [ "ar": "تفضيلات", "ca": "Preferències", "cs": "Předvolby", "da": "Indstillinger", "de": "Einstellungen", "el": "Προτιμήσεις", "en": "Preferences", "en_AU": "Preferences", "en_GB": "Preferences", "es": "Preferencias", "es_419": "Preferencias", "fi": "Asetukset", "fr": "Préférences", "fr_CA": "Préférences", "he": "העדפות", "hi": "प्राथमिकता", "hr": "Postavke", "hu": "Beállítások", "id": "Preferensi", "it": "Preferenze", "ja": "環境設定", "ko": "환경설정", "ms": "Keutamaan", "nl": "Voorkeuren", "no": "Valg", "pl": "Preferencje", "pt": "Preferências", "pt_PT": "Preferências", "ro": "Preferințe", "ru": "Настройки", "sk": "Nastavenia", "sv": "Inställningar", "th": "การตั้งค่า", "tr": "Tercihler", "uk": "Параметри", "vi": "Tùy chọn", "zh_CN": "偏好设置", "zh_HK": "偏好設定", "zh_TW": "偏好設定" ]

	static func localizedPreferences(for locale: Locale = Locale.current) -> String {
		if let languageCode = locale.languageCode, let regionCode = locale.regionCode {
			let identifier = "\(languageCode)_\(regionCode)"

			if let localizedString = System.preferencesLocalized[identifier] {
				return localizedString
			}
			if let localizedString = System.preferencesLocalized[languageCode] {
				return localizedString
			}
		}

		// fallback to English locale
		return System.preferencesLocalized["en"]!
	}
}

extension NSView {
	@discardableResult
	func constrainToSuperviewBounds() -> [NSLayoutConstraint] {
		guard let superview = superview else {
			preconditionFailure("superview has to be set first")
		}

		var result = [NSLayoutConstraint]()
		result.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
		result.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
		translatesAutoresizingMaskIntoConstraints = false
		superview.addConstraints(result)

		return result
	}
}

extension NSEvent {
	/// Events triggered by user interaction.
	static let userInteractionEvents: [NSEvent.EventType] = {
		var events: [NSEvent.EventType] = [
			.leftMouseDown,
			.leftMouseUp,
			.rightMouseDown,
			.rightMouseUp,
			.leftMouseDragged,
			.rightMouseDragged,
			.keyDown,
			.keyUp,
			.scrollWheel,
			.tabletPoint,
			.otherMouseDown,
			.otherMouseUp,
			.otherMouseDragged,
			.gesture,
			.magnify,
			.swipe,
			.rotate,
			.beginGesture,
			.endGesture,
			.smartMagnify,
			.quickLook,
			.directTouch
		]

		if #available(macOS 10.10.3, *) {
			events.append(.pressure)
		}

		return events
	}()

	/// Whether the event was triggered by user interaction.
	var isUserInteraction: Bool {
		return NSEvent.userInteractionEvents.contains(type)
	}
}

extension Bundle {
	var appName: String {
		return string(forInfoDictionaryKey: "CFBundleDisplayName")
			?? string(forInfoDictionaryKey: "CFBundleName")
			?? string(forInfoDictionaryKey: "CFBundleExecutable")
			?? "<Unknown App Name>"
	}

	private func string(forInfoDictionaryKey key: String) -> String? {
		// `object(forInfoDictionaryKey:)` prefers localized info dictionary over the regular one automatically
		return object(forInfoDictionaryKey: key) as? String
	}
}
