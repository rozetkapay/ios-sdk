//
//  PaymentViewParameters.swift
//  
//
//  Created by Ruslan Kasian Dev on 03.09.2024.
//

import Foundation

public struct PaymentViewParameters {
    let cardNameField: FieldRequirement
    let emailField: FieldRequirement
    let cardholderNameField: FieldRequirement

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
