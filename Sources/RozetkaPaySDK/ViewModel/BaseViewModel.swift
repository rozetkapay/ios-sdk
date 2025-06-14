//
//  BaseViewModel.swift
//
//
//  Created by Ruslan Kasian Dev on 19.09.2024.
//

import SwiftUI
import OSLog

class BaseViewModel: ObservableObject {
    //MARK: - Properties
    let client: ClientAuthParametersProtocol
    let viewParameters: ViewParametersProtocol
    let themeConfigurator: RozetkaPayThemeConfigurator
    let provideCardPaymentSystemUseCase: ProvideCardPaymentSystemUseCase
    
    //MARK: - UI Properties
    @Published var alertItem: CustomAlertItem?
    
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
    @Published var errorMessageEmail: String? = nil
    
    //MARK: - Inits
    init(
        client: ClientAuthParametersProtocol,
        viewParameters: ViewParametersProtocol,
        themeConfigurator: RozetkaPayThemeConfigurator,
        provideCardPaymentSystemUseCase: ProvideCardPaymentSystemUseCase
    ) {
        self.client = client
        self.viewParameters = viewParameters
        self.themeConfigurator = themeConfigurator
        self.provideCardPaymentSystemUseCase = provideCardPaymentSystemUseCase
    }
    
    //MARK: - Methods
    
    func validateAll() -> ValidationResultModel? {
        guard let validCardNumber = validateCardNumber(cardNumber),
              let validExpiryDate = validateExpiryDate(expiryDate),
              let validCVV = validateCVV(cvv)
        else {
            return nil
        }
        
        ///
        var validEmail: String? = nil
        switch viewParameters.emailField {
        case .optional:
            if !email.isNilOrEmpty {
                guard let value = validateEmail(email) else {
                    return nil
                }
                validEmail = value
            }
        case .none:
            break
        case .required:
            guard let value = validateEmail(email) else {
                return nil
            }
            validEmail = value
        }
        
        ///
        var validCardholderName: String? = nil
        switch viewParameters.cardholderNameField {
        case .optional:
            if !cardholderName.isNilOrEmpty {
                guard let value = validateCardholderName(cardholderName) else {
                    return nil
                }
                validCardholderName = value
            }
        case .none:
            break
        case .required:
            guard let value = validateCardholderName(cardholderName) else {
                return nil
            }
            validCardholderName = value
        }
        
        
        var validCardName: String? = nil
        switch viewParameters.cardNameField {
        case .optional:
            if !cardName.isNilOrEmpty {
                guard let value = validateCardName(cardName) else {
                    return nil
                }
                validCardName = value
            }
        case .none:
            break
        case .required:
            guard let value = validateCardName(cardName) else {
                return nil
            }
            validCardName = value
        }
        
        return ValidationResultModel(
            cardNumber: validCardNumber,
            cardExpMonth: validExpiryDate.month,
            cardExpYear: validExpiryDate.year,
            cardCvv: validCVV,
            cardName: validCardName,
            cardholderName: validCardholderName,
            customerEmail: validEmail
        )
    }
    
    func startLoader() {
        DispatchQueue.main.async {
            self.isLoading = true
        }
    }
    
    func stopLoader() {
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
    
    func setTestData() {
    #if DEBUG
        cardName = "test"
        cardNumber = "4242 4242 4242 4242"
        expiryDate = "12/29"
        cvv = "123"
        cardholderName = "Test Test"
        email = "test@test.com"
    #endif
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
            expirationValidationRule: RozetkaPaySdk.validationRules.cardExpirationDateValidationRule
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
            errorMessageEmail = nil
            return value
        case let .error(message):
            errorMessageEmail = message
            return nil
        }
    }
    
    @discardableResult
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
    
    @discardableResult
    private func validateCardName(_ value: String?) -> String? {
        switch CardNameValidator().validate(value: value) {
        case .valid:
            errorMessageCardName = nil
            return value
        case let .error(message):
            errorMessageCardName = message
            return nil
        }
    }
}
