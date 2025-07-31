//
//  TokenizedCard.swift
//  
//
//  Created by Ruslan Kasian Dev on 27.08.2024.
//

import Foundation

public struct TokenizedCard: Codable {
    public let token: String
    public let name: String?
    public let email: String?
    public let cardInfo: CardInfo

    public struct CardInfo: Codable {
        public let maskedNumber: String
        public let expiresAt: String
        public let paymentSystem: String?
        public let bank: String?
        public let isoA3Code: String?
        public let cardType: String?
    }
    
    init(
        token: String,
        expiresAt: String,
        maskedNumber: String,
        name: String? = nil,
        email: String? = nil,
        paymentSystem: String? = nil,
        bank: String? = nil,
        isoA3Code: String? = nil,
        cardType: String? = nil
    ) {
        self.token = token
        self.name = name
        self.email = email

        var _paymentSystem = paymentSystem
        if _paymentSystem.isNilOrEmpty {
            _paymentSystem = ProvideCardPaymentSystemUseCase().invoke(cardNumberPrefix: maskedNumber)?.rawValue
        }
        
        self.cardInfo = CardInfo(
            maskedNumber: maskedNumber,
            expiresAt: expiresAt,
            paymentSystem: _paymentSystem,
            bank: bank,
            isoA3Code: isoA3Code,
            cardType: cardType
        )
    }
}

extension TokenizedCard: CustomDebugStringConvertible {
    public var debugDescription: String {
        """
        TokenizedCard(
            token: \(token),
            name: \(name ?? "nil"),
            email: \(email ?? "nil"),
            cardInfo: \(cardInfo.debugDescription)
        )
        """
    }
}

extension TokenizedCard.CardInfo: CustomDebugStringConvertible {
    public var debugDescription: String {
        """
        CardInfo(
            maskedNumber: \(maskedNumber),
            expiresAt: \(expiresAt),
            paymentSystem: \(paymentSystem ?? "nil"),
            bank: \(bank ?? "nil"),
            isoA3Code: \(isoA3Code ?? "nil"),
            cardType: \(cardType ?? "nil")
        )
        """
    }
}
