//
//  CardData.swift
//  
//
//  Created by Ruslan Kasian Dev on 27.08.2024.
//

import Foundation

public struct CardData: Identifiable {
    public let id = UUID()

    public var cardName: String?
    public var cardNumber: String
    public var expiryDate: CardExpirationDate
    public var cvv: String
    
    public var cardholderName: String?
    public var email: String?
    
    public init(
        cardName: String?,
        cardNumber: String,
        expiryDate: CardExpirationDate,
        cvv: String,
        cardholderName: String?,
        email: String?
    ) {
        self.cardName = cardName
        self.cardNumber = cardNumber
        self.expiryDate = expiryDate
        self.cvv = cvv
        self.cardholderName = cardholderName
        self.email = email
    }
}
