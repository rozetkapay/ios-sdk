//
//  CardNumberMask.swift
//
//
//  Created by Ruslan Kasian Dev on 28.08.2024.
//

import Foundation

public final class CardNumberMask: TextMasking {
    private static let MAX_CREDIT_CARD_NUMBER_LENGTH = 19
    
    private let separator:  String

    init(separator: String = " ") {
        self.separator = separator
    }

    public func format(text: String) -> String {
        let digits = text.filter { $0.isNumber }
        var formattedText = ""
        for (index, digit) in digits.enumerated() {
            if index != 0 && (index % 4) == 0 {
                formattedText.append(separator)
            }
            formattedText.append(digit)
            if formattedText.count == Self.MAX_CREDIT_CARD_NUMBER_LENGTH + separator.count * (Self.MAX_CREDIT_CARD_NUMBER_LENGTH / 4) {
                break
            }
        }
        return formattedText
    }
    
    public func format(mask: String) -> String {
        let characters = mask.filter { $0.isNumber || $0 == "*" }
        var formattedText = ""
        
        for (index, character) in characters.enumerated() {
            if index != 0 && (index % 4) == 0 {
                formattedText.append(separator)
            }
            formattedText.append(character)
            if formattedText.count == Self.MAX_CREDIT_CARD_NUMBER_LENGTH + separator.count * (Self.MAX_CREDIT_CARD_NUMBER_LENGTH / 4) {
                break
            }
        }
        return formattedText
    }
    
    public func maskAndFormat(text: String) -> String {
        
        let digits = text.filter { $0.isNumber }
        
        guard digits.count > 4 else {
            return text
        }
        
        let maskedDigits = String(repeating: "*", count: max(0, digits.count - 4)) + digits.suffix(4)
        
        var formattedMaskedText = ""
        for (index, character) in maskedDigits.enumerated() {
            if index != 0 && (index % 4) == 0 {
                formattedMaskedText.append(separator)
            }
            formattedMaskedText.append(character)
            if formattedMaskedText.count == Self.MAX_CREDIT_CARD_NUMBER_LENGTH + separator.count * (Self.MAX_CREDIT_CARD_NUMBER_LENGTH / 4) {
                break
            }
        }
        
        return formattedMaskedText
    }
}
