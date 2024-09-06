//
//  OptionalStringValidator.swift
//  
//
//  Created by Ruslan Kasian Dev on 27.08.2024.
//

import Foundation

class OptionalStringValidator: Validator {
    
    private let validator: Validator
    
    init(validator: Validator) {
        self.validator = validator
    }
    
    override func validate(value: String?) -> ValidationResult {
        if value.isNilOrBlank {
            return .valid
        } else {
            return validator.validate(value: value)
        }
    }
}
