//
//  RozetkaPaySdkValidationRules.swift
//
//
//  Created by Ruslan Kasian Dev on 18.08.2024.
//

import Foundation

/// A container for customizable SDK input validation rules.
///
/// Allows overriding default input validators such as expiration date checks,
/// which can be used for different UX/UI or business logic scenarios.
public struct RozetkaPaySdkValidationRules {
    
    /// Validation rule for card expiration date (MM/YY).
    let cardExpirationDateValidationRule: CardExpirationDateValidationRule

    /// Initializes the validation rules.
    ///
    /// - Parameter cardExpirationDateValidationRule: The validation rule for the card's expiration date.
    /// Defaults to `RozetkaPaySdkValidationRulesDefaults.cardExpirationDateValidationRule`.
    public init(
        cardExpirationDateValidationRule: CardExpirationDateValidationRule = RozetkaPaySdkValidationRulesDefaults.cardExpirationDateValidationRule
    ) {
        self.cardExpirationDateValidationRule = cardExpirationDateValidationRule
    }
}

/// Default validation rules used by the SDK.
public enum RozetkaPaySdkValidationRulesDefaults {
    
    /// Default implementation for validating card expiration dates.
    public static let cardExpirationDateValidationRule: CardExpirationDateValidationRule = DefaultCardExpirationDateValidationRule()
}
