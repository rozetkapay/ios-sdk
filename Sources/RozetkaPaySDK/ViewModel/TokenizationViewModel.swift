//
//  TokenizationViewModel.swift
//
//
//  Created by Ruslan Kasian Dev on 20.08.2024.
//

import SwiftUI

class TokenizationViewModel: ObservableObject {

    //MARK: - Properties
    private let client: ClientWidgetParameters
    private let viewParameters: TokenizationViewParameters
    private let themeConfigurator: RozetkaPayThemeConfigurator
    private let provideCardPaymentSystemUseCase: ProvideCardPaymentSystemUseCase
    private let callback: ((TokenizationResult) -> Void)?
    
    //MARK: - UI Properties
    @Published var isLoaded: Bool = true
    
    @Published var cardNumber: String? = nil
    @Published var cvv: String?
    @Published var expiryDate: String? = nil
    
    @Published var cardName: String? = nil
    @Published var cardholderName: String? = nil
    @Published var email: String? = nil

    @Published var errorMessageCardNumber: String? = nil
    @Published var errorMessageCvv: String? = nil
    @Published var errorMessageExpiryDate: String? = nil
    
    @Published var errorMessageCardName: String? = nil
    @Published var errorMessageCardholderName: String? = nil
    @Published var errorMessagEmail: String? = nil
    
    var isShowCardName: Bool = false
    var isShowCardholderName: Bool = false
    var isShowEmail: Bool = false

    @Published var detectedPaymentSystem: PaymentSystem? = nil

    var paymentSystemLogoName: String {
        detectedPaymentSystem?.logoName ?? PaymentSystem.defaultLogoName
    }

    init(
          parameters: TokenizationParameters,
//         parseCardDataUseCase: ParseCardDataUseCase,
//         tokenizeCardUseCase: TokenizeCardUseCase,
//          resourcesProvider: ResourcesProvider,
        callback: @escaping (TokenizationResult) -> Void
    ) {
        self.client = parameters.client
        self.viewParameters = parameters.viewParameters
        self.themeConfigurator = parameters.themeConfigurator
        self.provideCardPaymentSystemUseCase = ProvideCardPaymentSystemUseCase()
        self.callback = callback

        self.isShowCardName = viewParameters.cardNameField.isShow
        self.isShowCardholderName = viewParameters.cardholderNameField.isShow
        self.isShowEmail = viewParameters.emailField.isShow
        setupBindings()

    }
    
    private func setupBindings() {
        $cardNumber
            .map { self.detectPaymentSystem($0) }
            .assign(to: &$detectedPaymentSystem)
    }
    
    func validateAll() {
        guard let validCardNumber = validateCardNumber(cardNumber),
              let validExpiryDate = validateExpiryDate(expiryDate),
              let validCVV = validateCVV(cvv)
        else {
            return
        }
        
        
        if !email.isNilOrEmpty {
            guard let validEmail = validateEmail(email) else {
                return
            }
        }
            
            
        let maskedNumer = CardNumberMask().maskAndFormat(text: validCardNumber)
        callback?(
            .success(
                TokenizedCard(
                    token: "test token1",
                    name: cardName,
                    cardInfo: TokenizedCard.CardInfo(
                        maskedNumber: maskedNumer,
                        paymentSystem: detectedPaymentSystem?.rawValue,
                        bank: nil,
                        isoA3Code: nil,
                        cardType: nil
                    )
                )
            )
        )
    }

    @discardableResult private func detectPaymentSystem(_ value: String?) -> PaymentSystem? {
        return provideCardPaymentSystemUseCase.invoke(cardNumberPrefix: value)
    }

    @discardableResult func validateCardNumber(_ value: String?) -> String? {
        switch CardNumberValidator().validate(value: value) {
        case .valid:
            errorMessageCardNumber = nil
            return value
        case let .error(message):
            errorMessageCardNumber = message
            return nil
        }
    }
    
    @discardableResult func validateExpiryDate(_ value: String?) -> CardExpirationDate? {
        switch CardExpirationDateValidator(
            expirationValidationRule: RozetkaPaySdkValidationRules().cardExpirationDateValidationRule
        ).validate(value: value) {
        case .valid:
            errorMessageExpiryDate = nil
            return CardExpirationDate(rawString: value)
        case .error(let message):
            errorMessageExpiryDate = message
            return nil
        }
    }

    @discardableResult func validateCVV(_ value: String?) -> String? {
        switch CardCVVValidator().validate(value: value) {
        case .valid:
            errorMessageCvv = nil
            return value
        case let .error(message):
            errorMessageCvv = message
            return nil
        }
    }
    
    @discardableResult func validateEmail(_ value: String?) -> String? {
        
        switch EmailValidator().validate(value: value) {
        case .valid:
            errorMessagEmail = nil
            return value
        case let .error(message):
            errorMessagEmail = message
            return nil
        }
    }

}
