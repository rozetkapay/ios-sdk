//
//  CardholderNameValidator.swift
//
//
//  Created by Ruslan Kasian Dev on 27.08.2024.
//

import Foundation

class CardholderNameValidator: Validator {

    override func validate(value: String?) -> ValidationResult {
        if value.isNilOrBlank {
            return .error(message: Localization.rozetka_pay_form_validation_cardholder_name_empty.description)
        } else {
            return .valid
        }
    }
}
