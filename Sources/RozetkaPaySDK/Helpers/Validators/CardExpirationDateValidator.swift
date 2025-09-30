//
//  CardExpDateValidator.swift
//
//
//  Created by Ruslan Kasian Dev on 27.08.2024.
//

import Foundation

class CardExpirationDateValidator: Validator {
    static let MAX_CREDIT_CARD_EXPIRATION_DATE_LENGTH = 5
    
    private let expirationValidationRule: CardExpirationDateValidationRule
    private let currentLocalDateProvider: () -> Date
    
    init(
        expirationValidationRule: CardExpirationDateValidationRule,
        currentLocalDateProvider: @escaping () -> Date = Date.init
    ) {
        self.expirationValidationRule = expirationValidationRule
        self.currentLocalDateProvider = currentLocalDateProvider
    }
    
    override func validate(value: String?) -> ValidationResult {
        guard let value = value.isNilOrEmptyValue else {
            return .invalid(
                message: Localization.rozetka_pay_form_validation_exp_date_empty.description
            )
        }
        
        guard let expDate = CardExpirationDate(rawString: value) else {
            return .invalid(
                message: Localization.rozetka_pay_form_validation_exp_date_incorrect.description
            )
        }
        
        guard (1...12).contains(expDate.month) else {
            return .invalid(
                message: Localization.rozetka_pay_form_validation_exp_date_incorrect.description
            )
        }
        
        let currentDate = currentLocalDateProvider()
        
        switch expirationValidationRule.validate(
            currentDate: currentDate,
            expYear: expDate.year,
            expMonth: expDate.month
        ) {
        case true:
            return .valid(value: value)
        case false:
            return .invalid(message: Localization.rozetka_pay_form_validation_exp_date_expired.description)
        }
        
    }
}
