//
//  CardCVVValidator.swift
//
//
//  Created by Ruslan Kasian Dev on 27.08.2024.
//

import Foundation

class CardCVVValidator: Validator {
    static let MAX_CREDIT_CARD_CVV_LENGTH = 3
    
    override func validate(value: String?) -> ValidationResult {
        guard let value = value.isNilOrEmptyValue else {
            return .invalid(
                message: Localization.rozetka_pay_form_validation_cvv_empty.description
            )
        }
        
        guard value.count == Self.MAX_CREDIT_CARD_CVV_LENGTH,
                value.range(of: "^[0-9]+$", options: .regularExpression) != nil
        else {
            return .invalid(
                message: Localization.rozetka_pay_form_validation_cvv_incorrect.description
            )
        }
        
        return .valid(value: value)
    }

}
