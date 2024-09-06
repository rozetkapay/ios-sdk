//
//  ExpirationDateMask.swift
//
//
//  Created by Ruslan Kasian Dev on 28.08.2024.
//

import Foundation

public final class ExpirationDateMask: TextMasking {
    private static let MAX_CREDIT_CARD_EXPIRATION_DATE_LENGTH = 4
    
    private let separator:  String

    init(separator: String = "/") {
        self.separator = separator
    }

    public func format(text: String) -> String {
        let digits = text.filter { $0.isNumber }
        var formattedText = ""
        for (index, digit) in digits.enumerated() {
            if index == 2 {
                formattedText.append(separator)
            }
            formattedText.append(digit)
            if formattedText.count == Self.MAX_CREDIT_CARD_EXPIRATION_DATE_LENGTH + separator.count {
                break
            }
        }
        return formattedText
    }
}
