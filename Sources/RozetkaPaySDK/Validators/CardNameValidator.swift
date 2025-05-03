//
//  CardNameValidator.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 02.05.2025.
//

import Foundation

class CardNameValidator: Validator {

    override func validate(value: String?) -> ValidationResult {
        if value.isNilOrBlank {
            return .error(message: Localization.rozetka_pay_form_validation_card_name_empty.description)
        } else {
            return .valid
        }
    }
}
