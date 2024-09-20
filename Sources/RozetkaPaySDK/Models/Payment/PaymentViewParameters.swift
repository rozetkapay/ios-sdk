//
//  PaymentViewParameters.swift
//  
//
//  Created by Ruslan Kasian Dev on 03.09.2024.
//

import Foundation

public protocol ViewParametersProtocol {
    var cardNameField: FieldRequirement { get}
    var emailField: FieldRequirement { get }
    var cardholderNameField: FieldRequirement {get}
}

public struct PaymentViewParameters: ViewParametersProtocol {
    public let cardNameField: FieldRequirement
    public let emailField: FieldRequirement
    public let cardholderNameField: FieldRequirement

    public init(
        cardNameField: FieldRequirement = .none,
        emailField: FieldRequirement = .none,
        cardholderNameField: FieldRequirement = .none
    ) {
        self.cardNameField = cardNameField
        self.emailField = emailField
        self.cardholderNameField = cardholderNameField
    }
}
