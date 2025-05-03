//
//  Validator.swift
//
//
//  Created by Ruslan Kasian Dev on 27.08.2024.
//

import Foundation

public typealias ValidationTextFieldResult = (ValidationResult)->()

public class Validator {
    func validate(value: String?) -> ValidationResult {
        fatalError("This method should be overridden")
    }

    func isValid(value: String?) -> Bool {
        return validate(value: value).isValid
    }
}

public enum ValidationResult {
    case valid
    case error(message: String)

    var isValid: Bool {
        switch self {
        case .valid:
            return true
        case .error:
            return false
        }
    }
}

public final class ValidatorsComposer: Validator {
    private var allValidators: [Validator]

    init(validators: [Validator] = []) {
        self.allValidators = validators
    }

    func addValidator(_ validator: Validator) {
        allValidators.append(validator)
    }

    override func validate(value: String?) -> ValidationResult {
        for validator in allValidators {
            let validationResult = validator.validate(value: value)
            if case .error = validationResult {
                return validationResult
            }
        }
        return .valid
    }
}
