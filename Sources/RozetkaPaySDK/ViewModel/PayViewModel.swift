//
//  File.swift
//  
//
//  Created by Ruslan Kasian Dev on 29.08.2024.
//


import SwiftUI
import PassKit

class PayViewModel:  BaseViewModel {
    //    private val clientAuthParameters: ClientAuthParameters,
    //        private val parameters: PaymentParameters,
    //        private val resourcesProvider: ResourcesProvider,
    //        private val provideCardPaymentSystemUseCase: ProvideCardPaymentSystemUseCase,
    //        private val parseCardDataUseCase: ParseCardDataUseCase,
    //        private val createPaymentUseCase: CreatePaymentUseCase,
    //        private val checkPaymentStatusUseCase: CheckPaymentStatusUseCase,
    //        private val googlePayInteractor: GooglePayInteractor?,
    private let requestGroup = DispatchGroup()
    
    let applePaymentHandler: ApplePaymentHandler?
    let applePayConfig: ApplePayConfig?

    let amountParameters: PaymentParameters.AmountParameters
    let orderId: String
    let callbackUrl: String?
    
    let isAllowTokenization: Bool
    let isAllowApplePay: Bool
 
    let amountWithCurrencyStr: String
    
    @Published var start3dsConfirmation = false //
    private let callback: ((PaymentResult) -> Void)?
    
    //MARK: _ Init
    init(
        parameters: PaymentParameters,
        provideCardPaymentSystemUseCase: ProvideCardPaymentSystemUseCase? = nil,
        callback: @escaping (PaymentResult) -> Void
    ) {
        
        self.amountParameters = parameters.amountParameters
        self.amountWithCurrencyStr = MoneyFormatter.formatCoinsToMoney(
            coins: parameters.amountParameters.amount,
            currency: Currency.getSymbol(currencyCode: parameters.amountParameters.currencyCode)
        )
        
        self.orderId = parameters.orderId
        self.callbackUrl = parameters.callbackUrl
        self.isAllowTokenization = parameters.isAllowTokenization
        
        self.applePayConfig = parameters.applePayConfig
        self.isAllowApplePay = parameters.applePayConfig?.checkApplePayAvailability() ?? false
        self.applePaymentHandler = ApplePaymentHandler(config: parameters.applePayConfig)
        
        self.callback = callback

        super.init(
            client: parameters.client,
            viewParameters: parameters.viewParameters,
            themeConfigurator: parameters.themeConfigurator,
            provideCardPaymentSystemUseCase: provideCardPaymentSystemUseCase ?? ProvideCardPaymentSystemUseCase()
        )
    }

//    override func loading(validModel: ValidationResultModel) {
//        callback?(
//            .complete(orderId: "test", paymentId: "test")
//        )
//    }
//    
    override func loading(validModel: ValidationResultModel) {
        var errors = false
        
        requestGroup.enter()
        let model = CardRequestModel(
            cardNumber: validModel.cardNumber,
            cardExpMonth: validModel.cardExpMonth,
            cardExpYear: validModel.cardExpYear,
            cardCvv: validModel.cardCvv,
            cardholderName: validModel.cardholderName,
            customerEmail: validModel.customerEmail
        )
        tokenizeCard(key: client.key, model: model)
        
        requestGroup.enter()
       
        let payModel = PaymentRequestModel(
            amount: amountParameters.amount.currencyFormatAmount(),
            currency: amountParameters.currencyCode,
            externalId: orderId,
            customer: CustomerDto(paymentMethod: .cardToken(CardTokenDto(token: "тут нужен токен карті")))
        )
                                        
        payByCard(key: client.key, model: payModel)
        
        requestGroup.notify(queue: .main) { [weak self] in
            self?.isLoading = false
        }
    }
    
    
   override func cancelled() {
        self.isLoading = false
        self.isError = false
        self.errorMessage = nil
       callback?(.cancelled)
    }
    
    
    func startApplePayPayment() {
        #warning("to do - startApplePayPayment")
        self.applePaymentHandler?.startPayment { (success) in
            if success {
                print("Success")
            } else {
                print("Failed")
            }
        }
    }
    
    private func payByCard(key: String, model: PaymentRequestModel) {
           self.isLoading = true
           self.isError = false
           self.errorMessage = nil
           
        
        PayService.createPayment(key: key, model: model) { [weak self] result in
//               DispatchQueue.main.async {
//                   
//                   switch result {
//                   case .complete(orderId: <#T##String#>, paymentId: <#T##String#>)
//                           
//                           .success(let success):
//                       self?.requestGroup.leave()
//                   case .failure(let error):
//                       switch error {
//                       case .cancelled:
//                           self?.requestGroup.leave()
//                       case let .failed(message, _):
//                           self?.requestGroup.leave()
//                       }
//                   }
//               }
           }
       }
    
    private func tokenizeCard(key: String, model: CardRequestModel) {
           self.isLoading = true
           self.isError = false
           self.errorMessage = nil
           
           TokenizationService.tokenizeCard(key: key, model: model) { [weak self] result in
               DispatchQueue.main.async {
                   
                   switch result {
                   case .success(let success):
                       self?.requestGroup.leave()
                   case .failure(let error):
                       switch error {
                       case .cancelled:
                           self?.requestGroup.leave()
                       case let .failed(message, _):
                           self?.requestGroup.leave()
                       }
                   }
               }
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
