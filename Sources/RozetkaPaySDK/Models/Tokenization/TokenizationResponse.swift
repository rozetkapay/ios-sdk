//
//  TokenizationResponse.swift
//
//
//  Created by Ruslan Kasian Dev on 12.09.2024.
//

import Foundation

struct TokenizationResponse: Decodable {
    let token: String
    let expiresAt: Date
    let cardMask: String
    let issuer: Issuer

    struct Issuer: Codable {
        let bank: String?
        let isoA3Code: String?
        let cardType: String?
        
        private enum CodingKeys: String, CodingKey {
            case bank
            case isoA3Code = "iso_a3_code"
            case cardType = "card_type"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.bank = try container.decodeIfPresent(String.self, forKey: .bank)
            self.isoA3Code = try container.decodeIfPresent(String.self, forKey: .isoA3Code)
            self.cardType = try container.decodeIfPresent(String.self, forKey: .cardType)
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case token = "token"
        case expiresAt = "expires_at"
        case cardMask = "card_mask"
        case issuer = "issuer"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.token = try container.decode(String.self, forKey: .token)
        self.cardMask = try container.decode(String.self, forKey: .cardMask)
        self.issuer = try container.decode(Issuer.self, forKey: .issuer)
        
        let expiresAtString = try container.decode(String.self, forKey: .expiresAt)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        guard let date = formatter.date(from: expiresAtString) else {
            throw DecodingError.dataCorruptedError(
                forKey: .expiresAt,
                in: container,
                debugDescription: "Date string does not match format expected by formatter."
            )
        }
        
        self.expiresAt = date
    }
}

extension TokenizationResponse {
    func convertToTokenizedCard() -> TokenizedCard {
        return TokenizedCard(
            token:  self.token,
            maskedNumber: self.cardMask,
            bank: self.issuer.bank,
            isoA3Code: self.issuer.isoA3Code,
            cardType: self.issuer.cardType
        )
    }
}
