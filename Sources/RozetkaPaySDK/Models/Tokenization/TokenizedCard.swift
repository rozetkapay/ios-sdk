//
//  TokenizedCard.swift
//  
//
//  Created by Ruslan Kasian Dev on 27.08.2024.
//

import Foundation

public struct TokenizedCard: Codable {
    public let token: String
    public var name: String?
    public var expiry: String?
    public let cardInfo: CardInfo?

    public struct CardInfo: Codable {
        public let maskedNumber: String?
        public let paymentSystem: String?
        public let bank: String?
        public let isoA3Code: String?
        public let cardType: String?
    }
    
    init(
        token: String,
        name: String? = nil,
        maskedNumber: String? = nil,
        paymentSystem: String? = nil,
        bank: String? = nil,
        isoA3Code: String? = nil,
        cardType: String? = nil
    ) {
        self.token = token
        self.name = name
        var _paymentSystem = paymentSystem
        if _paymentSystem.isNilOrEmpty {
            _paymentSystem = ProvideCardPaymentSystemUseCase().invoke(cardNumberPrefix: maskedNumber)?.rawValue
        }
        
        var _maskedNumber = maskedNumber
        if let value = _maskedNumber?.isEmptyOrValue {
            _maskedNumber = CardNumberMask().format(mask: value)
        }
        
        self.cardInfo = CardInfo(
            maskedNumber: _maskedNumber,
            paymentSystem: _paymentSystem,
            bank: bank,
            isoA3Code: isoA3Code,
            cardType: cardType
        )
    }
    
    mutating func setup(name: String?) {
        self.name = name
    }

    mutating func setup(expiry: String) {
        self.expiry = expiry
    }
}

extension TokenizedCard: CustomDebugStringConvertible {
    public var debugDescription: String {
        """
        TokenizedCard(
            token: \(token),
            name: \(name ?? "nil"),
            expiry: \(expiry ?? "nil"),
            cardInfo: \(cardInfo?.debugDescription ?? "nil")
        )
        """
    }
}

extension TokenizedCard.CardInfo: CustomDebugStringConvertible {
    public var debugDescription: String {
        """
        CardInfo(
            maskedNumber: \(maskedNumber ?? "nil"),
            paymentSystem: \(paymentSystem ?? "nil"),
            bank: \(bank ?? "nil"),
            isoA3Code: \(isoA3Code ?? "nil"),
            cardType: \(cardType ?? "nil")
        )
        """
    }
}
