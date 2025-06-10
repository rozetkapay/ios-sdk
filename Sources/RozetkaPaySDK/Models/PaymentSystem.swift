//
//  PaymentSystem.swift
//
//
//  Created by Ruslan Kasian Dev on 20.08.2024.
//

import Foundation

/// An enumeration representing different payment systems.
enum PaymentSystem: String, Identifiable, CaseIterable {
    /// Represents the Visa payment system.
    case visa = "Visa"
    /// Represents the MasterCard payment system.
    case masterCard = "MasterCard"
    /// Represents the Prostir payment system.
    case prostir = "Prostir"
    
    /// A unique identifier for the payment system, which is its raw value (name).
    var id: String { self.rawValue }
    
    /// A string alias used to represent the payment system in a more convenient format.
    var alias: String {
        switch self {
        case .visa:
            return "visa"
        case .masterCard:
            return "mastercard"
        case .prostir:
            return "prostir"
        }
    }
    
    /// An array of prefixes associated with the payment system.
    /// Each prefix is either an integer or a range of integers that can be used to identify the payment system from a card number.
    var prefixes: [PrefixContainable] {
        switch self {
        case .visa:
            return [
                PrefixInt(prefix: 4)
            ]
        case .masterCard:
            return [
                PrefixRange(range: 51...55),
                PrefixRange(range: 2221...2720),
                PrefixInt(prefix: 5018),
                PrefixInt(prefix: 5020),
                PrefixInt(prefix: 5038),
                PrefixInt(prefix: 5893),
                PrefixInt(prefix: 6304),
                PrefixInt(prefix: 6759),
                PrefixInt(prefix: 6761),
                PrefixInt(prefix: 6762),
                PrefixInt(prefix: 6763)
            ]
        case .prostir:
            return [
                PrefixInt(prefix: 9)
            ]
        }
    }
    
    /// The name of the logo image associated with the payment system.
    var logoName: String {
        switch self {
        case .visa:
            return DomainImages.visa.name
        case .masterCard:
            return DomainImages.mastercard.name
        case .prostir:
            return DomainImages.prostir.name
        }
    }
    
    /// The default logo name to be used when no specific payment system is identified.
    static var defaultLogoName: String {
        return DomainImages.card.name
    }
}
