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
}
