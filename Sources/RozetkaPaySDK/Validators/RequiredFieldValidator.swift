//
//  RequiredFieldValidator.swift
//  
//
//  Created by Ruslan Kasian Dev on 27.08.2024.
//

import Foundation

class RequiredFieldValidator: Validator {

    override func validate(value: String?) -> ValidationResult {
        if value.isNilOrBlank {
            return .error(message: Localization.rozetka_pay_form_validation_field_empty.description)
        } else {
            return .valid
        }
    }
}
