//
//  BatchProduct.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 29.05.2025.
//

import Foundation

public struct BatchProduct: Codable {
    public let category: String
    public let currency: String
    public let description: String
    public let id: String
    public let image: String
    public let name: String
    public let netAmount: String
    public let vatAmount: String
    public let quantity: String
    public let url: String

    public init(
        category: String,
        currency: String,
        description: String,
        id: String,
        image: String,
        name: String,
        netAmountInCoins: Int64,
        vatAmountInCoins: Int64,
        quantity: String,
        url: String
    ) {
        self.category = category
        self.currency = currency
        self.description = description
        self.id = id
        self.image = image
        self.name = name
        self.netAmount = MoneyFormatter.formatCoinsToRawMoneyString(coins: netAmountInCoins)
        self.vatAmount = MoneyFormatter.formatCoinsToRawMoneyString(coins: vatAmountInCoins)
        self.quantity = quantity
        self.url = url
    }

    private enum CodingKeys: String, CodingKey {
        case category
        case currency
        case description
        case id
        case image
        case name
        case netAmount = "net_amount"
        case vatAmount = "vat_amount"
        case quantity
        case url
    }
}
