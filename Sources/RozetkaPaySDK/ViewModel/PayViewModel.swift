//
//  File.swift
//  
//
//  Created by Ruslan Kasian Dev on 29.08.2024.
//


import SwiftUI
import PassKit

class PayViewModel: ObservableObject {
    //    private val clientAuthParameters: ClientAuthParameters,
    //        private val parameters: PaymentParameters,
    //        private val resourcesProvider: ResourcesProvider,
    //        private val provideCardPaymentSystemUseCase: ProvideCardPaymentSystemUseCase,
    //        private val parseCardDataUseCase: ParseCardDataUseCase,
    //        private val createPaymentUseCase: CreatePaymentUseCase,
    //        private val checkPaymentStatusUseCase: CheckPaymentStatusUseCase,
    //        private val googlePayInteractor: GooglePayInteractor?,
    
    
    
    //MARK: - Properties
    let client: ClientAuthParameters
    let viewFieldsParameters: PaymentViewParameters
    let themeConfigurator: RozetkaPayThemeConfigurator
    let provideCardPaymentSystemUseCase: ProvideCardPaymentSystemUseCase
    
    let applePayConfig: ApplePayConfig?

    let amountParameters: PaymentParameters.AmountParameters
    let orderId: String
    let callbackUrl: String?
    
    let isShowCardName: Bool
    let isShowCardholderName: Bool
    let isShowEmail: Bool
    
    let isAllowTokenization: Bool
    let isAllowApplePay: Bool
 
    let amountWithCurrencyStr: String
    
    private let callback: ((PaymentResult) -> Void)?
    
    //MARK: - UI Properties
    
    @Published var isLoaded: Bool = true
    @Published var isNeedToTokenizationCard: Bool = false
    
    @Published var cardNumber: String? = nil
    @Published var cvv: String?
    @Published var expiryDate: String? = nil
    @Published var cardholderName: String? = nil

    @Published var errorMessageCardNumber: String? = nil
    @Published var errorMessageCvv: String? = nil
    @Published var errorMessageExpiryDate: String? = nil
    @Published var errorMessageCardholderName: String? = nil

    @Published var detectedPaymentSystem: PaymentSystem? = nil

   
    
    
    var paymentSystemLogoName: String {
        detectedPaymentSystem?.logoName ?? PaymentSystem.defaultLogoName
    }
    
    //MARK: _ Init
    init(
        parameters: PaymentParameters,
        callback: @escaping (PaymentResult) -> Void
    ) {

        self.client = parameters.client
        self.viewFieldsParameters = parameters.viewFieldsParameters
        self.themeConfigurator = parameters.themeConfigurator
        
        self.amountParameters = parameters.amountParameters
        self.amountWithCurrencyStr = MoneyFormatter.formatCoinsToMoney(
            coins: parameters.amountParameters.amount,
            currency: Currency.getSymbol(currencyCode: parameters.amountParameters.currencyCode)
        )
        
        self.orderId = parameters.orderId
        self.callbackUrl = parameters.callbackUrl
        self.isAllowTokenization = parameters.isAllowTokenization
        
        self.isShowCardName = parameters.viewFieldsParameters.cardNameField.isShow
        self.isShowCardholderName = parameters.viewFieldsParameters.cardholderNameField.isShow
        self.isShowEmail = parameters.viewFieldsParameters.emailField.isShow
        
        self.applePayConfig = parameters.applePayConfig
        self.isAllowApplePay = parameters.applePayConfig?.checkApplePayAvailability() ?? false
        
        self.provideCardPaymentSystemUseCase = ProvideCardPaymentSystemUseCase()
        self.callback = callback

        self.setupBindings()
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
        
        callback?(
            .complete(orderId: "test", paymentId: "test")
        )
    }

    @discardableResult private func detectPaymentSystem(_ value: String?) -> PaymentSystem? {
        return provideCardPaymentSystemUseCase.invoke(cardNumberPrefix: value)
    }

    func validateCardNumber(_ value: String?) -> String? {
        switch CardNumberValidator().validate(value: value) {
        case .valid:
            errorMessageCardNumber = nil
            return nil
        case let .error(message):
            errorMessageCardNumber = message
            return value
        }
    }
    
    func validateExpiryDate(_ value: String?) -> CardExpirationDate? {
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

    func validateCVV(_ value: String?) -> String? {
        switch CardCVVValidator().validate(value: value) {
        case .valid:
            errorMessageCvv = nil
            return nil
        case let .error(message):
            errorMessageCvv = message
            return nil
        }
    }

    
//    private fun checkGooglePayParameters() {
//        if (parameters.googlePayConfig is GooglePayConfig.Test) {
//            Log.w(
//                Logger.DEFAULT_TAG,
//                   """
//                   ⚠️ WARNING: GOOGLE PAY IS CONFIGURED IN TEST MODE! ⚠️
//                   ⚠️ THIS IS A DEVELOPMENT CONFIGURATION AND SHOULD NOT BE USED IN PRODUCTION. ⚠️
//                   DETAILS:
//                   - Gateway: ${parameters.googlePayConfig.gateway}
//                   - Merchant ID: ${parameters.googlePayConfig.merchantId}
//                   
//                   Please ensure this configuration is switched to Production mode before releasing the app.
//                   """.trimIndent()
//            )
//        }
//    }
    
    
}
