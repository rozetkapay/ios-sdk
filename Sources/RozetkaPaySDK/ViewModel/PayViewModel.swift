//
//  File.swift
//
//
//  Created by Ruslan Kasian Dev on 29.08.2024.
//
import SwiftUI
import PassKit

final class PayViewModel:  BaseViewModel {
    
    //MARK: - Properties
    let applePaymentService: ApplePaymentService?
    let applePayConfig: ApplePayConfig?
    
    let amountParameters: PaymentParameters.AmountParameters
    let orderId: String
    let callbackUrl: String?
    
    let isAllowTokenization: Bool
    let isAllowApplePay: Bool
    
    let amountWithCurrencyStr: String
    
    @Published var isThreeDSConfirmationPresented = false
    var threeDSModel: ThreeDSRequest?
    
    private let onResultCallback: (PaymentResultCompletionHandler)?
    
    //MARK: - Init
    init(
        parameters: PaymentParameters,
        provideCardPaymentSystemUseCase: ProvideCardPaymentSystemUseCase? = nil,
        onResultCallback: @escaping PaymentResultCompletionHandler
    ) {
        
        self.amountParameters = parameters.amountParameters
        self.amountWithCurrencyStr = MoneyFormatter.formatCoinsToMoney(
            coins: parameters.amountParameters.total,
            currency: Currency.getSymbol(currencyCode: parameters.amountParameters.currencyCode)
        )
        
        self.orderId = parameters.orderId
        self.callbackUrl = parameters.callbackUrl
        self.isAllowTokenization = parameters.isAllowTokenization
        
        self.applePayConfig = parameters.applePayConfig
        self.isAllowApplePay = parameters.applePayConfig?.checkApplePayAvailability() ?? false
        self.applePaymentService = ApplePaymentService(
            orderId: parameters.orderId,
            config: parameters.applePayConfig,
            amount:  parameters.amountParameters
        )
        
        self.onResultCallback = onResultCallback
        
        super.init(
            client: parameters.client,
            viewParameters: parameters.viewParameters,
            themeConfigurator: parameters.themeConfigurator,
            provideCardPaymentSystemUseCase: provideCardPaymentSystemUseCase ?? ProvideCardPaymentSystemUseCase()
        )
        
        setTestData()
    }
    
    //MARK: - overrides
    override func cancelled() {
        self.isLoading = false
        self.isError = false
        self.errorMessage = nil
        self.isThreeDSConfirmationPresented = false
        self.threeDSModel = nil
        
        onResultCallback?(
            .cancelled(
                orderId: orderId,
                paymentId: nil
            )
        )
    }
    
    override func loading(validModel: ValidationResultModel) {
        if isAllowTokenization && isNeedToTokenizationCard {
            startPayByTokenizedCard(validModel)
        }else {
            startPayByCard(validModel)
        }
    }
    
    override func resetState() {
        self.isError = false
        self.errorMessage = nil
        self.isThreeDSConfirmationPresented = false
        self.threeDSModel = nil
    }
}

private extension PayViewModel {
    
    private func buildPaymentModel(paymentMethod: PaymentMethod) -> PaymentRequestModel {
        return PaymentRequestModel(
            amount: self.amountParameters.amount.currencyFormatAmount(),
            currency: self.amountParameters.currencyCode,
            externalId: self.orderId,
            callbackUrl: self.callbackUrl,
            customer: Customer(paymentMethod: paymentMethod)
        )
    }
}

//MARK: - PayByCard
extension PayViewModel {
#warning("in process - startPayByCard")
    /// payment with card data not supported yet
    /// it will be implemented in the future releases
    private func startPayByCard(_ validModel: ValidationResultModel) {
        alertItem = CustomAlertItem(
            type: .soon,
            title: "Soon ...",
            message: Localization.rozetka_pay_payment_error_unsupported.description
        )
    }
    
#warning("in process - startPayByTokenizedCard")
    /// payment with tokenizedCard data not supported yet
    /// it will be implemented in the future releases
    private func startPayByTokenizedCard(_ validModel: ValidationResultModel) {
        alertItem = CustomAlertItem(
            type: .soon,
            title: "Soon ...",
            message: Localization.rozetka_pay_payment_tokenized_error_unsupported.description
        )
    }
    
}


//MARK: - PayByTokenizedCard
extension PayViewModel {
    private func inprocess(_ validModel: ValidationResultModel) {
        resetState()
        startLoader()
        
        var payModel: PaymentRequestModel?
        var paymentResult: CreatePaymentResult?
        var errorMessage: String?
        
        let requestGroup = DispatchGroup()
        
        ///tokenizeCard
        requestGroup.enter()
        let model = CardRequestModel(
            cardName: validModel.cardName,
            cardNumber: validModel.cardNumber,
            cardExpMonth: validModel.cardExpMonth,
            cardExpYear: validModel.cardExpYear,
            cardCvv: validModel.cardCvv,
            cardholderName: validModel.cardholderName,
            customerEmail: validModel.customerEmail
        )
        
        TokenizationService.tokenizeCard(
            key: client.secondKey ?? "",
            model: model,
            result: { [weak self] result in
                switch result {
                case .success(let model):
                    payModel = self?.buildPaymentModel(
                        paymentMethod: .cardToken(
                            CardToken(token: model.token)
                        )
                    )
                case .failure(let error):
                    switch error {
                    case .cancelled:
                        paymentResult = .cancelled(
                            orderId: self?.orderId,
                            paymentId: nil
                        )
                    case let .failed(message, _):
                        let errorModel = PaymentError(
                            code: ErrorResponseCode.failedToVerifyCard.rawValue,
                            message: message,
                            orderId: self?.orderId,
                            paymentId: nil,
                            type: ErrorResponseType.paymentError.rawValue
                        )
                        
                        paymentResult = .failed(error: errorModel)
                        errorMessage = message
                    }
                }
                requestGroup.leave()
            }
        )
        ///
        requestGroup.wait()
        ///
        if let payModel = payModel {
            ///payByCard
            requestGroup.enter()
            
            PayService.createPayment(
                key: client.key,
                model: payModel,
                result: { [weak self] result in
                    switch result {
                    case let .failed(error):
                        errorMessage = error.localizedDescription
                    default:
                        break
                    }
                    paymentResult = result
                    requestGroup.leave()
                }
            )
        }
        
        requestGroup.notify(queue: .main) { [weak self] in
            DispatchQueue.main.async {
                self?.processPaymentResult(
                    paymentResult,
                    errorMessage: errorMessage
                )
            }
        }
    }
}

//MARK: - PayByApplePay
extension PayViewModel {
    func startPayByApplePay() {
        resetState()
        
        self.isLoading = false
        self.isError = false
        self.errorMessage = nil
        self.isThreeDSConfirmationPresented = false
        self.threeDSModel = nil
        
        self.isLoading = true
        self.isError = false
        self.errorMessage = nil
        self.isThreeDSConfirmationPresented = false
        self.threeDSModel = nil
        
        var payModel: PaymentRequestModel?
        var paymentResult: CreatePaymentResult?
        var errorMessage: String?
        
        let requestGroup = DispatchGroup()
        ///applePay
        requestGroup.enter()
        self.applePaymentService?.startPayment { [weak self] result in
            switch result {
            case let .success(orderId, applePayToken):
                payModel = self?.buildPaymentModel(
                    paymentMethod: .applePay(
                        ApplePay(token: applePayToken)
                    )
                )
            case let .cancelled(orderId):
                paymentResult = .cancelled(
                    orderId: orderId,
                    paymentId: nil
                )
            case let .failed(error):
                paymentResult = .failed(error: error)
            }
            
            requestGroup.leave()
        }
        ///
        requestGroup.wait()
        ///
        if let payModel = payModel {
            ///payByCard
            requestGroup.enter()
            PayService.createPayment(
                key: client.key,
                model: payModel,
                result: { [weak self] result in
                    switch result {
                    case let .failed(error):
                        errorMessage = error.localizedDescription
                    default:
                        break
                    }
                    paymentResult = result
                    requestGroup.leave()
                }
            )
        }
        
        requestGroup.notify(queue: .main) { [weak self] in
            DispatchQueue.main.async {
                self?.processPaymentResult(
                    paymentResult,
                    errorMessage: errorMessage
                )
            }
        }
    }
    
    private func showError(_ message: String?) {
        self.isError = true
        self.errorMessage = message
        self.isThreeDSConfirmationPresented = false
        self.threeDSModel = nil
    }
    
    private func processPaymentResult(_ paymentResult: CreatePaymentResult?, errorMessage: String?) {
        self.stopLoader()
        
        guard let paymentResult = paymentResult else {
            self.showError(errorMessage)
            return
        }
        
        switch paymentResult {
        case let .cancelled(orderId, paymentId):
            self.onResultCallback?(
                .cancelled(
                    orderId: orderId,
                    paymentId: paymentId
                )
            )
        case let .success(orderId, paymentId):
            self.onResultCallback?(
                .complete(
                    orderId: orderId,
                    paymentId: paymentId
                )
            )
        case let .confirmation3DsRequired(orderId, paymentId, url, callbackUrl):
            self.threeDSModel = ThreeDSRequest(
                acsUrl: url,
                termUrl: callbackUrl,
                orderId: orderId,
                paymentId: paymentId
            )
            self.isThreeDSConfirmationPresented = true
        case let .failed(error):
            
            if error.code == .transactionAlreadyPaid {
                self.onResultCallback?(
                    .failed(error: error)
                )
                return
            }
            self.showError(error.localizedDescription)
        }
    }
}

//MARK: - CheckPayment
extension PayViewModel {
    private func startCheckPayment(orderId: String, paymentId: String) {
        resetState()
        startLoader()
        
        let model = CheckPaymentRequestModel(
            orderId: orderId,
            paymentId: paymentId,
            externalId: orderId
        )
        
        PayService.checkPayment(
            key: client.key,
            model: model,
            result: {[weak self] result in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    switch result {
                    case let .failed(error):
                        if error.code == .transactionAlreadyPaid {
                            self?.onResultCallback?(
                                .failed(error: error)
                            )
                            return
                        }
                        self?.errorMessage = error.localizedDescription
                        self?.isError = true
                    default:
                        self?.onResultCallback?(result)
                    }
                }
            }
        )
    }
    
    func handleThreeDSResult(_ result: ThreeDSResult) {
        resetState()
        stopLoader()
        
        switch result {
        case let .success(orderId, paymentId),
            let .cancelled(orderId, paymentId):
            startCheckPayment(
                orderId: orderId,
                paymentId: paymentId
            )
        case let .failed(error):
            guard let orderId = error.orderId, let paymentId = error.paymentId else {
                onResultCallback?(
                    .failed(error: error)
                )
                return
            }
            startCheckPayment(
                orderId: orderId,
                paymentId: paymentId
            )
        }
    }
}
