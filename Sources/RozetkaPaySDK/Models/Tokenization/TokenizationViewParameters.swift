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
    public let isVisibleCardInfoTitle: Bool
    public let isVisibleCardInfoLegalView: Bool
    public var stringResources: StringResources
    
    public init(
        cardNameField: FieldRequirement = .none,
        emailField: FieldRequirement = .none,
        cardholderNameField: FieldRequirement = .none
    ) {
        self.cardNameField = cardNameField
        self.emailField = emailField
        self.cardholderNameField = cardholderNameField
        self.isVisibleCardInfoTitle = true
        self.isVisibleCardInfoLegalView = true
        self.stringResources =  StringResources(
            cardFormTitle: Localization.rozetka_pay_form_card_info_title.description,
            buttonTitle: Localization.rozetka_pay_form_save_card.description
        )
    }
}
