//
//  RozetkaPaySdkValidationRules.swift
//
//
//  Created by Ruslan Kasian Dev on 18.08.2024.
//

import Foundation

public struct RozetkaPaySdkValidationRules {
    let cardExpirationDateValidationRule: CardExpirationDateValidationRule
    
    public init(cardExpirationDateValidationRule: CardExpirationDateValidationRule = RozetkaPaySdkValidationRulesDefaults.cardExpirationDateValidationRule) {
        self.cardExpirationDateValidationRule = cardExpirationDateValidationRule
    }
}

public enum RozetkaPaySdkValidationRulesDefaults {
    public static let cardExpirationDateValidationRule: CardExpirationDateValidationRule = DefaultCardExpirationDateValidationRule()
}
