//
//  TokenizationViewParameters.swift
//
//
//  Created by Ruslan Kasian Dev on 02.09.2024.
//

import Foundation

public struct TokenizationViewParameters: ViewParametersProtocol {
    public let cardNameField: FieldRequirement
    public let emailField: FieldRequirement
    public let cardholderNameField: FieldRequirement

    public init(
        cardNameField: FieldRequirement = .optional,
        emailField: FieldRequirement = .optional,
        cardholderNameField: FieldRequirement = .optional
    ) {
        self.cardNameField = cardNameField
        self.emailField = emailField
        self.cardholderNameField = cardholderNameField
    }
}
