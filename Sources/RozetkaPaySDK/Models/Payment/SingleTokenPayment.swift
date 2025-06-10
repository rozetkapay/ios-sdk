//
//  SingleTokenPayment.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 28.05.2025.
//
import Foundation

/// Configuration for payments using a pre-tokenized card.
/// This mode disables card input and selection.
public struct SingleTokenPayment: Codable {
    /// Token string representing the card to be charged.
    let token: String

    public init(token: String) {
        self.token = token
    }
}
