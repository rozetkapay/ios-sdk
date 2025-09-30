//
//  Validator.swift
//
//
//  Created by Ruslan Kasian Dev on 27.08.2024.
//

import Foundation

public class Validator {
    func validate(value: String?) -> ValidationResult {
        fatalError("This method should be overridden")
    }
}

public enum ValidationResult {
    case none
    case valid(value: String?)
    case invalid(message: String)
}

public extension ValidationResult {

    var errorMessage: String? {
        if case let .invalid(message) = self {
            return message
        }
        return nil
    }
    
    var value: String? {
        if case let .valid(value) = self {
            return value
        }
        return nil
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
            if case .invalid = validationResult {
                return validationResult
            }
        }
        return .valid(value: value)
    }
}
