//
//  ValidationResultModel.swift
//
//
//  Created by Ruslan Kasian Dev on 19.09.2024.
//

import Foundation

struct ValidationResultModel {
    
    let cardNumber: String
    let cardExpMonth: Int
    let cardExpYear: Int
    let cardCvv: String
    let cardName: String?
    let cardholderName: String?
    let customerEmail: String?
    
    init(
        cardNumber: String,
        cardExpMonth: Int,
        cardExpYear: Int,
        cardCvv: String,
        cardName: String?,
        cardholderName: String? = nil,
        customerEmail: String? = nil
    ) {
        
        if cardNumber.containsNonDigits {
            self.cardNumber = cardNumber.digitsOnly
        }else {
            self.cardNumber = cardNumber
        }
        
        self.cardExpMonth = cardExpMonth
        self.cardExpYear = cardExpYear
        self.cardCvv = cardCvv
        self.cardholderName = cardholderName
        self.cardName = cardName
        self.customerEmail = customerEmail
        
    }
}
