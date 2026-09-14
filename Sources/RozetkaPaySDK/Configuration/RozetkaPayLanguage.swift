//
//  RozetkaPayLanguage.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 14.09.2026.
//
import Foundation

/// Language of the payment status descriptions returned by the API.
///
/// Set it once via `RozetkaPaySdk.initSdk(apiLanguage:)` to control which
/// localized variant of a status description is shown to the buyer.
public enum RozetkaPayLanguage: String {
    
    /// Follows the language of the device or app.
    case system
    
    /// Always Ukrainian, regardless of the device language.
    case ukrainian
    
    /// Always English, regardless of the device language.
    case english
}

extension RozetkaPayLanguage {
    
    /// Language the SDK currently resolves API text to.
    ///
    /// Combines the value configured in `RozetkaPaySdk.apiLanguage`
    /// with the current device language.
    static var effective: RozetkaPayLanguage {
        RozetkaPaySdk.apiLanguage.resolveEffective(languageCode: currentLanguageCode)
    }
    
    /// Resolves `.system` against a device language; `.ukrainian` and `.english` are returned as is.
    ///
    /// - Parameter languageCode: ISO 639-1 code of the current device language, e.g. `"uk"`.
    /// - Returns: `.english` for an English device language, `.ukrainian` for any other.
    func resolveEffective(languageCode: String) -> RozetkaPayLanguage {
        switch self {
        case .system:
            return languageCode == "en" ? .english : .ukrainian
        case .ukrainian, .english:
            return self
        }
    }
    
    /// ISO 639-1 code of the language the device or app currently runs in.
    static var currentLanguageCode: String {
        let identifier = Locale.preferredLanguages.first ?? Locale.current.identifier
        return identifier
            .split(whereSeparator: { $0 == "-" || $0 == "_" })
            .first
            .map { $0.lowercased() } ?? ""
    }
}
