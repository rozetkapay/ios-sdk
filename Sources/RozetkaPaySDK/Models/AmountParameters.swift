//
//  AmountParameters.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 29.05.2025.
//
import Foundation

/// Contains information about the amount, tax, and currency.
public struct AmountParameters: Codable {
    /// Amount in coins.
    let amount: Int64
    /// ISO 4217 currency code.
    let currencyCode: String
    /// Optional tax amount in coins.
    let tax: Int64?
    /// Total amount including tax.
    let total: Int64
    
    /// Initializes from integer amounts.
    public init(
        amount: Int64,
        tax: Int64? = nil,
        total: Int64? = nil,
        currencyCode: String
    ) {
        self.amount = amount
        self.tax = tax
        if let total = total.isNilOrEmptyValue {
            self.total = total
        } else {
            self.total = self.amount + (self.tax ?? 0)
        }
        self.currencyCode = currencyCode
    }
}
