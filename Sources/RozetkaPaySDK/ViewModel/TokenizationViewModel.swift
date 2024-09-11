//
//  TokenizationViewModel.swift
//
//
//  Created by Ruslan Kasian Dev on 20.08.2024.
//

import SwiftUI
import OSLog

class TokenizationViewModel: ObservableObject {

    //MARK: - Properties
    private let client: ClientWidgetParameters
    private let viewParameters: TokenizationViewParameters
    private let themeConfigurator: RozetkaPayThemeConfigurator
    private let provideCardPaymentSystemUseCase: ProvideCardPaymentSystemUseCase
    private let callback: ((TokenizationResult) -> Void)?
    
    //MARK: - UI Properties
    @Published var isLoading = false
    @Published var isError = false
    @Published var errorMessage: String?
    
    ///
    @Published var cardNumber: String? = nil
    @Published var cvv: String?
    @Published var expiryDate: String? = nil
    ///
    @Published var cardName: String? = nil
    @Published var cardholderName: String? = nil
    @Published var email: String? = nil
    ///
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

        cardName = "test"
        cardNumber = "4242 4242 4242 4242"
        expiryDate = "12/29"
        cvv = "123"
        cardholderName = "Test Test"
        email = "casiocompa@gmail.com"
        
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
        
        ///
        var validEmail: String? = nil
        switch viewParameters.emailField {
        case .optional:
            if !email.isNilOrEmpty {
                guard let value = validateEmail(email) else {
                    return
                }
                validEmail = value
            }
        case .none:
           break
        case .required:
            guard let value = validateEmail(email) else {
                return
            }
            validEmail = value
        }
        
        ///
        var validCardholderName: String? = nil
        switch viewParameters.cardholderNameField {
        case .optional:
            if !cardholderName.isNilOrEmpty {
                guard let value = validateCardholderName(cardholderName) else {
                    return
                }
                validCardholderName = value
            }
        case .none:
           break
        case .required:
            guard let value = validateCardholderName(cardholderName) else {
                return
            }
            validCardholderName = value
        }
        
        ///
        let model = CardRequestModel(
            cardNumber: validCardNumber,
            cardExpMonth: validExpiryDate.month,
            cardExpYear: validExpiryDate.year,
            cardCvv: validCVV,
            cardholderName: validCardholderName,
            customerEmail: validEmail
        )
        tokenizeCard(apiKey: client.widgetKey, model: model)
        
    }

    @discardableResult
    private func detectPaymentSystem(_ value: String?) -> PaymentSystem? {
        return provideCardPaymentSystemUseCase.invoke(cardNumberPrefix: value)
    }

    @discardableResult 
    private func validateCardNumber(_ value: String?) -> String? {
        switch CardNumberValidator().validate(value: value) {
        case .valid:
            errorMessageCardNumber = nil
            return value
        case let .error(message):
            errorMessageCardNumber = message
            return nil
        }
    }
    
    @discardableResult 
    private func validateExpiryDate(_ value: String?) -> CardExpirationDate? {
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

    @discardableResult 
    private func validateCVV(_ value: String?) -> String? {
        switch CardCVVValidator().validate(value: value) {
        case .valid:
            errorMessageCvv = nil
            return value
        case let .error(message):
            errorMessageCvv = message
            return nil
        }
    }
    
    @discardableResult
    private func validateEmail(_ value: String?) -> String? {
        switch EmailValidator().validate(value: value) {
        case .valid:
            errorMessagEmail = nil
            return value
        case let .error(message):
            errorMessagEmail = message
            return nil
        }
    }

    private func validateCardholderName(_ value: String?) -> String? {
        switch CardholderNameValidator().validate(value: value) {
        case .valid:
            errorMessageCardholderName = nil
            return value
        case let .error(message):
            errorMessageCardholderName = message
            return nil
        }
    }
    
    func cancelled() {
        self.isLoading = false
        self.isError = false
        self.errorMessage = nil
        callback?(.failure(.cancelled))
    }
    
    private func tokenizeCard(apiKey: String, model: CardRequestModel) {
           self.isLoading = true
           self.isError = false
           self.errorMessage = nil
           
           TokenizationService.tokenizeCard(apiKey: apiKey, model: model) { [weak self] result in
               DispatchQueue.main.async {
                   self?.isLoading = false
                   switch result {
                   case .success(let success):
                       self?.isError = false
                       self?.callback?(.success(success))
                   case .failure(let error):
                       switch error {
                       case .cancelled:
                           self?.cancelled()
                       case let .failed(message, _):
                           self?.isError = true
                           self?.errorMessage = message
                       }
                   }
               }
           }
       }
}
