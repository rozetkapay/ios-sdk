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

}
