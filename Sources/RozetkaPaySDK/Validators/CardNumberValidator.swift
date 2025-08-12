//
//  CardNumberValidator.swift
//
//
//  Created by Ruslan Kasian Dev on 27.08.2024.
//

import Foundation

/// A validator class for validating credit card numbers.
class CardNumberValidator: Validator {
    /// The minimum length for a valid card number.
    static let MIN_CARD_NUMBER_LENGTH = 16
    /// The maximum length for a valid card number.
    static let MAX_CARD_NUMBER_LENGTH = 19
    
    /// The maximum length for a valid card number with spaces.
    static let MAX_CARD_NUMBER_LENGTH_WITH_SPACES = 23
    
    /// Validates the provided card number string.
    ///
    /// - Parameter value: The card number string to be validated.
    /// - Returns: A `ValidationResult` indicating whether the card number is valid or contains errors.
    override func validate(value: String?) -> ValidationResult {
        guard let value = value.isNilOrEmptyValue else {
            return .error(message: Localization.rozetka_pay_form_validation_card_number_empty.description)
        }
        
        let _value = value.replacingOccurrences(of: " ", with: "")
        
        let isValid = _value.range(of: "^[0-9]+$", options: .regularExpression) != nil
            && _value.count >= Self.MIN_CARD_NUMBER_LENGTH
            && _value.count <= Self.MAX_CARD_NUMBER_LENGTH
            && validateCardNumberWithLuhnAlgorithm(cardNumber: _value)
        
        if isValid {
            return .valid
        } else {
            return .error(message: Localization.rozetka_pay_form_validation_card_number_incorrect.description)
        }
    }
    
    /// Validates the card number using the Luhn algorithm.
    ///
    /// The Luhn algorithm is a simple checksum formula used to validate various identification numbers, such as credit card numbers.
    ///
    /// - Parameter cardNumber: The card number string to be validated.
    /// - Returns: `true` if the card number is valid according to the Luhn algorithm; otherwise, `false`.
    private func validateCardNumberWithLuhnAlgorithm(cardNumber: String) -> Bool {
        let digits = cardNumber.compactMap { Int(String($0)) }
        var sum = 0
        for (index, digit) in digits.reversed().enumerated() {
            let isOdd = index % 2 == 1
            sum += isOdd ? (digit * 2 > 9 ? digit * 2 - 9 : digit * 2) : digit
        }
        return sum % 10 == 0
    }
}

