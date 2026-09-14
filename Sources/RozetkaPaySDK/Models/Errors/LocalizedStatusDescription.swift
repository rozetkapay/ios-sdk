//
//  LocalizedStatusDescription.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 08.09.2026.
//
import Foundation

/// Payment response that carries a status description in every language the API provides.
protocol LocalizedStatusDescription {
    
    /// Language-agnostic description, from `status_description`.
    var statusDescription: String? { get }
    
    /// English description, from `status_description_en`.
    var statusDescriptionEn: String? { get }
    
    /// Ukrainian description, from `status_description_uk`.
    var statusDescriptionUk: String? { get }
}

extension LocalizedStatusDescription {
    
    /// Returns the status description in the given language.
    ///
    /// - Parameter language: Language to resolve the description for.
    /// - Returns: Description in `language`, `statusDescription` when that language is missing
    ///   from the response, or `nil` when the response carried no description at all.
    func resolveDescription(language: RozetkaPayLanguage) -> String? {
        let localized: String?
        
        switch language {
        case .english:
            localized = statusDescriptionEn
        case .ukrainian, .system:
            localized = statusDescriptionUk
        }
        
        return localized ?? statusDescription
    }
}
