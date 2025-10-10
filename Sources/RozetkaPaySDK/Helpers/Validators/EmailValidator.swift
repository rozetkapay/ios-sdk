//
//  EmailValidator.swift
//
//
//  Created by Ruslan Kasian Dev on 27.08.2024.
//

import Foundation

class EmailValidator: Validator {

    private let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

    override func validate(value: String?) -> ValidationResult {
        
        guard let value = value.isNilOrEmptyValue else {
            return .invalid(
                message: Localization.rozetka_pay_form_validation_email_empty.description
            )
        }
        
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        if predicate.evaluate(with: value) {
            return .valid(value: value)
        } else {
            return .invalid(message: Localization.rozetka_pay_form_validation_email_incorrect.description)
        }
    }
}
