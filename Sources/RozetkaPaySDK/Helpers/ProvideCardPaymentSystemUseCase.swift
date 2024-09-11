//
//  ProvideCardPaymentSystemUseCase.swift
//
//
//  Created by Ruslan Kasian Dev on 02.09.2024.
//

import Foundation

public class ProvideCardPaymentSystemUseCase {
    /// Detects the payment system of a card number based on its prefix.
    ///
    /// The function checks the first 6 digits of the card number and matches them against known prefixes to determine the payment system.
    ///
    /// - Parameter value: The card number string to detect the payment system for.
    /// - Returns: An optional `PaymentSystem` that represents the detected payment system; `nil` if no system is detected.
    func invoke(cardNumberPrefix: String?) -> PaymentSystem? {
        guard let value = cardNumberPrefix else {
            return nil
        }
        
        let _value = value.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "*", with: "")
        
        guard _value.count >= 4, _value.range(of: "^[0-9]+$", options: .regularExpression) != nil else {
            return nil
        }
        
        if let digits = Int(_value.prefix(4)) {
            return PaymentSystem.allCases.first { system in
                system.prefixes.contains {
                    $0.contains(digits)
                }
            }
        } else {
            return nil
        }
    }
}
