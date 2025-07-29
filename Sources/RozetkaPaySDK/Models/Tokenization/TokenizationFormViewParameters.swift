//
//  TokenizationFormViewParameters.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 11.07.2025.
//
import Foundation

public struct TokenizationFormViewParameters: ViewParametersProtocol {
    public let cardNameField: FieldRequirement
    public let emailField: FieldRequirement
    public let cardholderNameField: FieldRequirement
    public let isVisibleCardInfoTitle: Bool
    public let isVisibleCardInfoLegalView: Bool
    public let stringResources: StringResources

    public init(
        cardNameField: FieldRequirement = .none,
        emailField: FieldRequirement = .none,
        cardholderNameField: FieldRequirement = .none,
        isVisibleCardInfoTitle: Bool = true,
        isVisibleCardInfoLegalView: Bool = true,
        stringResources: StringResources = StringResources(
            cardFormTitle: Localization.rozetka_pay_form_card_info_title.description,
            buttonTitle: Localization.rozetka_pay_form_save_card.description
        )
    ) {
        self.cardNameField = cardNameField
        self.emailField = emailField
        self.cardholderNameField = cardholderNameField
        self.isVisibleCardInfoTitle = isVisibleCardInfoTitle
        self.isVisibleCardInfoLegalView = isVisibleCardInfoLegalView
        self.stringResources = stringResources
    }
}
