//
//  BatchOrder.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 29.05.2025.
//
import Foundation

public struct BatchOrder: Encodable {
    public let apiKey: String
    public let amount: String
    public let description: String
    public let externalId: String
    public let unifiedExternalId: String?
    public let products: [BatchProduct]?

    public init(
        apiKey: String,
        amountInCoins: Int64,
        description: String,
        externalId: String,
        unifiedExternalId: String? = nil,
        products: [BatchProduct]? = nil
    ) {
        self.apiKey = apiKey
        self.amount =  MoneyFormatter.formatCoinsToRawMoneyString(coins: amountInCoins)
        self.description = description
        self.externalId = externalId
        self.unifiedExternalId = unifiedExternalId
        self.products = products
    }
    
    private enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
        case amount = "amount"
        case description
        case externalId = "external_id"
        case unifiedExternalId = "unified_external_id"
        case products
    }
}
