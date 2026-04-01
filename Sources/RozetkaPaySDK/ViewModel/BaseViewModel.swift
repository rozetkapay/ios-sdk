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
    @Published var cvv: String? = nil
    @Published var expiryDate: String? = nil
    ///
    @Published var cardName: String? = nil
    @Published var cardholderName: String? = nil
    @Published var email: String? = nil
    ///
    @Published var cardNumberStatus: ValidationResult = .none
    @Published var cvvStatus: ValidationResult = .none
    @Published var expiryDateStatus: ValidationResult = .none
    @Published var cardNameStatus: ValidationResult = .none
    @Published var cardholderNameStatus: ValidationResult = .none
    @Published var emailStatus: ValidationResult = .none
    
    @Published var didPerformInitialValidation = false
    
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
        self.didPerformInitialValidation = false
    }
    
    //MARK: - Methods
    
    func validateAll() -> ValidationResultModel? {
        didPerformInitialValidation = true
        var isValid = true
        
        let _validCardNumber = validateCardNumber(cardNumber)
        let _validExpiryDate = validateExpiryDate(expiryDate)
        let _validCVV = validateCVV(cvv)
       
        ///
        var validEmail: String? = nil
        switch viewParameters.emailField {
        case .optional:
            if !email.isNilOrEmpty {
                if let value = validateEmail(email) {
                    validEmail = value
                }else {
                    isValid = false
                }
            }
        case .none:
            break
        case .required:
            if let value = validateEmail(email)  {
                validEmail = value
            }else {
                isValid = false
            }
        }
        
        ///
        var validCardholderName: String? = nil
        switch viewParameters.cardholderNameField {
        case .optional:
            if !cardholderName.isNilOrEmpty {
                if let value = validateCardholderName(cardholderName) {
                    validCardholderName = value
                }else {
                    isValid = false
                }
            }
        case .none:
            break
        case .required:
            if let value = validateCardholderName(cardholderName) {
                validCardholderName = value
            }else {
                isValid = false
            }
        }
        
        ///
        var validCardName: String? = nil
        switch viewParameters.cardNameField {
        case .optional:
            if !cardName.isNilOrEmpty {
                if let value = validateCardName(cardName)  {
                    validCardName = value
                }else {
                    isValid = false
                }
            }
        case .none:
            break
        case .required:
            if let value = validateCardName(cardName) {
                validCardName = value
            }else {
                isValid = false
            }
        }
        
        ///
        guard let validCardNumber = _validCardNumber,
              let validExpiryDate = _validExpiryDate,
              let validCVV = _validCVV
        else {
            return nil
        }
        
        guard isValid else {
            return nil
        }
        
        ///
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
    
    func clearFormFields() {
        DispatchQueue.main.async {
            self.cardNumber = nil
            self.cvv = nil
            self.expiryDate = nil
            self.cardName = nil
            self.cardholderName = nil
            self.email = nil
            
            self.cardNumberStatus = .none
            self.cvvStatus = .none
            self.expiryDateStatus = .none
            self.cardNameStatus = .none
            self.cardholderNameStatus = .none
            self.emailStatus = .none
            
            self.didPerformInitialValidation = false
        }
    }
    
    func setTestData() {
        #warning("MOC DATA")
//    #if DEBUG
//        cardName = "test"
//        cardNumber = "4242 4242 4242 4242"
//        expiryDate = "12/29"
//        cvv = "123"
//        cardholderName = "Test Test"
//        email = "test@test.com"
//    #endif
    }
    
    
    @discardableResult
    private func validateCardNumber(_ value: String?) -> String? {
        let status = CardNumberValidator().validate(value: value)
        cardNumberStatus = status
        return status.value
    }
    
    @discardableResult
    private func validateExpiryDate(_ value: String?) -> CardExpirationDate? {
        
        let status = CardExpirationDateValidator(
            expirationValidationRule: RozetkaPaySdk.validationRules.cardExpirationDateValidationRule
        ).validate(value: value)
        
        expiryDateStatus = status
        
        switch status{
        case .valid:
            return CardExpirationDate(rawString: value)
        case .invalid,
                .none:
            return nil
        }
    }
    
    @discardableResult
    private func validateCVV(_ value: String?) -> String? {
       
        let status = CardCVVValidator().validate(value: value)
        cvvStatus = status
        return status.value
    }
    
    @discardableResult
    private func validateEmail(_ value: String?) -> String? {
        let status = EmailValidator().validate(value: value)
        emailStatus = status
        return status.value
    }
    
    @discardableResult
    private func validateCardholderName(_ value: String?) -> String? {
        let status = CardholderNameValidator().validate(value: value)
        cardholderNameStatus = status
        return status.value
    }
    
    @discardableResult
    private func validateCardName(_ value: String?) -> String? {
        let status = CardNameValidator().validate(value: value)
        cardNameStatus = status
        return status.value
    }
}
