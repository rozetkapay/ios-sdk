//
//  File.swift
//
//
//  Created by Ruslan Kasian Dev on 29.08.2024.
//
import SwiftUI
import PassKit

final class PayViewModel:  BaseViewModel {
    
    private enum InitialPaymentType {
        case applePay
        case card
        case singleToken
        case unknown
        
        var iRetryEnabled: Bool {
            switch self {
            case .card, .singleToken:
                return true
            default:
                return false
            }
        }
    }
    
    private enum InitialPaymentMode {
        case single
        case batch
    }
    
    //MARK: - Properties
    let vStackSpacing: CGFloat = 16
    
    private var initialPaymentType: InitialPaymentType
    private let initialMode: InitialPaymentMode
    
    private let paymentType: PaymentTypeConfiguration
    private let applePaymentService: ApplePaymentService?
    private let amountParameters: AmountParameters
    private let externalId: String
    private let callbackUrl: String?
    private let resultUrl: String?
    private let batchOrders: [BatchOrder]?
    
    private let isNeedToReturnTokenizationCard: Bool
    private let isAllowApplePay: Bool
    
    private let amountWithCurrencyStr: String
    
    @Published var isThreeDSConfirmationPresented = false
    private var threeDSModel: ThreeDSRequest?
    
    private let onResultCallback: PaymentResultCompletionHandler?
    private let onBatchResultCallback: BatchPaymentResultCompletionHandler?
    
    //MARK: - Init
    init(
        parameters: PaymentParameters,
        provideCardPaymentSystemUseCase: ProvideCardPaymentSystemUseCase? = nil,
        onResultCallback: @escaping PaymentResultCompletionHandler
    ) {
        self.initialMode = .single
        self.initialPaymentType = .unknown
        
        self.amountParameters = parameters.amountParameters
        self.amountWithCurrencyStr = MoneyFormatter.formatCoinsToMoney(
            coins: parameters.amountParameters.total,
            currency: Currency.getSymbol(currencyCode: parameters.amountParameters.currencyCode)
        )
        
        self.externalId = parameters.externalId
        self.callbackUrl = parameters.callbackUrl
        self.resultUrl = nil
        self.isNeedToReturnTokenizationCard = parameters.paymentType.isNeedToReturnTokenizationCard
        
        self.paymentType = parameters.paymentType
        
        self.batchOrders = nil
        
        self.isAllowApplePay = parameters.paymentType.isAllowApplePay
        self.applePaymentService = parameters.applePaymentService
        
        self.onResultCallback = onResultCallback
        self.onBatchResultCallback = nil
        
        super.init(
            client: parameters.client,
            viewParameters: parameters.viewParameters,
            themeConfigurator: parameters.themeConfigurator,
            provideCardPaymentSystemUseCase: provideCardPaymentSystemUseCase ?? ProvideCardPaymentSystemUseCase()
        )
        
        checkIsNeedToPayByeTokenizedCard()
        setTestData()
    }
    
    init(
        parameters: BatchPaymentParameters,
        provideCardPaymentSystemUseCase: ProvideCardPaymentSystemUseCase? = nil,
        onResultCallback: @escaping BatchPaymentResultCompletionHandler
    ) {
        self.initialMode = .batch
        self.initialPaymentType = .unknown
        self.amountParameters = parameters.amountParameters
        self.amountWithCurrencyStr = MoneyFormatter.formatCoinsToMoney(
            coins: parameters.amountParameters.total,
            currency: Currency.getSymbol(currencyCode: parameters.amountParameters.currencyCode)
        )
        
        self.externalId = parameters.externalId
        self.callbackUrl = parameters.callbackUrl
        self.resultUrl = parameters.resultUrl
        self.isNeedToReturnTokenizationCard = parameters.paymentType.isNeedToReturnTokenizationCard
        
        self.paymentType = parameters.paymentType
        
        self.isAllowApplePay = parameters.paymentType.isAllowApplePay
        self.applePaymentService = parameters.applePaymentService
        
        self.batchOrders = parameters.orders
        
        self.onBatchResultCallback = onResultCallback
        self.onResultCallback = nil
        
        super.init(
            client: parameters.client,
            viewParameters: parameters.viewParameters,
            themeConfigurator: parameters.themeConfigurator,
            provideCardPaymentSystemUseCase: provideCardPaymentSystemUseCase ?? ProvideCardPaymentSystemUseCase()
        )
        
        checkIsNeedToPayByeTokenizedCard()
        setTestData()
    }
}

//MARK: -
extension PayViewModel {
    func getThreeDSModel() -> ThreeDSRequest? {
        return threeDSModel
    }
    
    func getIsRetryEnabled() -> Bool {
        return initialPaymentType.iRetryEnabled
    }
    
    func getAmountWithCurrency() -> String {
        return amountWithCurrencyStr
    }
    
    func cancelled() {
        DispatchQueue.main.async {
            self.isLoading = false
            self.isError = false
            self.errorMessage = nil
            self.isThreeDSConfirmationPresented = false
            self.threeDSModel = nil
            
            self.onResultCallback?(
                .cancelled(
                    externalId: self.externalId,
                    paymentId: nil
                )
            )
        }
    }
    
    func retryLoading() {
        switch initialPaymentType {
        case .singleToken:
            self.startPayByTokenizedCard()
        case .card:
            self.startPayByCard()
        default:
            resetState()
            initialPaymentType = .unknown
            break
        }
    }
    
    func resetState() {
        DispatchQueue.main.async {
            self.isError = false
            self.errorMessage = nil
            self.isThreeDSConfirmationPresented = false
            self.threeDSModel = nil
        }
    }
}

//MARK: -
private extension PayViewModel {
    
    func buildPaymentModel(paymentMethod: PaymentMethod) -> PaymentRequestModel {
        return PaymentRequestModel(
            amountInCoins: self.amountParameters.total,
            currency: self.amountParameters.currencyCode,
            externalId: self.externalId,
            callbackUrl: self.callbackUrl,
            customer: Customer(paymentMethod: paymentMethod)
        )
    }
    
    func buildBatchPaymentModel(paymentMethod: PaymentMethod, orders: [BatchOrder]) -> BatchPaymentRequestModel {
        return BatchPaymentRequestModel(
            currency: amountParameters.currencyCode,
            batchExternalId: self.externalId,
            resultUrl: self.resultUrl,
            callbackUrl: self.callbackUrl,
            customer: Customer(paymentMethod: paymentMethod),
            orders: orders
        )
    }
}

//MARK: - PayByCard
extension PayViewModel {
    
   private func checkIsNeedToPayByeTokenizedCard() {
        switch self.paymentType {
        case .singleToken:
            self.startPayByTokenizedCard()
        default:
            break
        }
    }
    
    func startPayByApplePay() {
        guard let appleService = self.applePaymentService else {
            initialPaymentType = .unknown
            return
        }
        initialPaymentType = .applePay
        resetState()
        startLoader()
        
        appleService.startPayment { [weak self] result in
            guard let self else {
                return
            }
            DispatchQueue.main.async {
                switch result {
                case let .success(_, token):
                    self.createPayment(fromApplePay: token)
                case let .cancelled(externalId):
                    self.processPaymentResult(
                        .cancelled(
                            externalId: externalId,
                            paymentId: nil
                        )
                    )
                case let .failed(error):
                    self.processPaymentResult(
                        .failed(error: error)
                    )
                }
            }
        }
    }
    
    func startPayByTokenizedCard() {
        switch self.paymentType {
        case .singleToken(let model):
            initialPaymentType = .singleToken
            resetState()
            startLoader()
            
            createPayment(from: model.token)
        default:
            initialPaymentType = .unknown
            break
        }
    }
    
    func startPayByCard() {
        guard let validModel: ValidationResultModel = self.validateAll() else {
            initialPaymentType = .unknown
            return
        }
        initialPaymentType = .card
        resetState()
        startLoader()
        
        let requestModel = CardRequestModel(
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
            model: requestModel,
            result: { [weak self] result in
                guard let self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .complete(let successModel):
                        self.createPayment(from: successModel)
                    case .failed(let error):
                        self.processPaymentResult(
                            error.convertToCreatePaymentResult(self.externalId)
                        )
                    case .cancelled:
                        self.processPaymentResult(
                            .cancelled(
                                externalId: self.externalId,
                                paymentId: nil
                            )
                        )
                    }
                }
            }
        )
    }
    
}

//MARK: - PayByCard
private extension PayViewModel {
    func showError(_ message: String?) {
        DispatchQueue.main.async {
            self.isError = true
            self.errorMessage = message
            self.isThreeDSConfirmationPresented = false
            self.threeDSModel = nil
        }
    }
    
    func createPayment(from model: TokenizedCard) {
        createPayment(
            with: .cardToken(CardToken(token: model.token)),
            tokenizedCard: self.isNeedToReturnTokenizationCard ? model : nil
        )
    }
    
    func createPayment(from token: String) {
        createPayment(with: .cardToken(
            CardToken(token: token)
        ))
    }
    
    func createPayment(fromApplePay token: String) {
        createPayment(with: .applePay(
            ApplePay(token: token)
        ))
    }
    
    func createPayment(
        with method: PaymentMethod,
        tokenizedCard: TokenizedCard? = nil
    ) {
        switch initialMode {
        case .single:
            let payModel = self.buildPaymentModel(paymentMethod: method)
            
            PayService.createPayment(
                key: self.client.key,
                model: payModel,
                result: { [weak self] result in
                    guard let self else { return }
                    DispatchQueue.main.async {
                        self.processPaymentResult(result, tokenizedCard)
                    }
                }
            )
        case .batch:
            guard let orders = batchOrders else {
                return
            }
            let payModel = buildBatchPaymentModel(paymentMethod: method, orders: orders)
            
            BatchPayService.createBatchPayment(
                key: client.key,
                model: payModel,
                result: { [weak self] result in
                    self?.processBatchPaymentResult(result, tokenizedCard)
                }
            )
        }
    }
    
    
    func processPaymentResult(_ result: CreatePaymentResult,_ tokenizedCard: TokenizedCard? = nil) {
        resetState()
        stopLoader()
        
        DispatchQueue.main.async {
            switch result {
            case let .cancelled(externalId, paymentId):
                self.onResultCallback?(
                    .cancelled(
                        externalId: externalId,
                        paymentId: paymentId
                    )
                )
            case let .success(externalId, paymentId):
                self.onResultCallback?(
                    .complete(
                        externalId: externalId,
                        paymentId: paymentId,
                        tokenizedCard: tokenizedCard
                    )
                )
            case let .confirmation3DsRequired(externalId, paymentId, url, callbackUrl):
                self.threeDSModel = ThreeDSRequest(
                    externalId: externalId,
                    acsUrl: url,
                    termUrl: callbackUrl,
                    paymentId: paymentId,
                    tokenizedCard: tokenizedCard
                )
                self.isThreeDSConfirmationPresented = true
                self.isError = false
                self.errorMessage = nil
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
    
    func processBatchPaymentResult(_ result: CreateBatchPaymentResult, _ tokenizedCard: TokenizedCard?) {
        resetState()
        stopLoader()
       
        DispatchQueue.main.async {
            switch result {
            case let .cancelled(batchExternalId):
                self.onBatchResultCallback?(
                    .cancelled(batchExternalId: batchExternalId)
                )
            case let .success(batchExternalId, ordersPayments):
                self.onBatchResultCallback?(
                    .complete(
                        batchExternalId: batchExternalId,
                        ordersPayments: ordersPayments,
                        tokenizedCard: tokenizedCard
                    )
                )
            case let .confirmation3DsRequired(batchExternalId, ordersPayments, url, callbackUrl):
                self.threeDSModel = ThreeDSRequest(
                    externalId: batchExternalId,
                    acsUrl: url,
                    termUrl: callbackUrl,
                    tokenizedCard: tokenizedCard,
                    ordersPayments: ordersPayments
                )
                
                self.isThreeDSConfirmationPresented = true
                self.isError = false
                self.errorMessage = nil
            case let .failed(batchExternalId, error):
                if error.code == .transactionAlreadyPaid {
                    self.onBatchResultCallback?(
                        .failed(
                            batchExternalId: batchExternalId,
                            error: error,
                            ordersPayments: nil
                        )
                    )
                    return
                }
                self.showError(error.localizedDescription)
            }
        }
    }

}

//MARK: - CheckPayment
extension PayViewModel {
    private func startCheckPayment(
        externalId: String?,
        paymentId: String?,
        tokenizedCard: TokenizedCard?
    ) {
        guard let externalId = externalId else {
            return
        }
        
        resetState()
        startLoader()
        
        let model = CheckPaymentRequestModel(
            externalId: externalId,
            paymentId: paymentId,
            tokenizedCard: tokenizedCard
        )
        
        PayService.checkPayment(
            key: client.key,
            model: model,
            result: {[weak self] result in
                guard let self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.stopLoader()
                    switch result {
                    case let .failed(error):
                        if error.code == .transactionAlreadyPaid {
                            self.onResultCallback?(
                                .failed(error: error)
                            )
                            return
                        }
                        self.errorMessage = error.localizedDescription
                        self.isError = true
                    default:
                        self.onResultCallback?(result)
                    }
                }
            }
        )
    }
    
    private func startCheckBatchPayment(
        batchExternalId: String?,
        tokenizedCard: TokenizedCard?,
        ordersPayments: [BatchOrderPaymentResult]?
    ) {
        guard let batchExternalId = batchExternalId else {
            return
        }
        
        resetState()
        startLoader()
        
        let model = CheckBatchPaymentRequestModel(
            batchExternalId: batchExternalId,
            tokenizedCard: tokenizedCard,
            ordersPayments: ordersPayments
        )
        
        BatchPayService.checkBatchPayment(
            key: client.key,
            model: model,
            result: {[weak self] result in
                guard let self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.stopLoader()
                    switch result {
                    case let .failed(batchExternalId, error, ordersPayments):
                        if error.code == .transactionAlreadyPaid {
                            self.onBatchResultCallback?(
                                .failed(
                                    batchExternalId: batchExternalId,
                                    error: error,
                                    ordersPayments: ordersPayments
                                )
                            )
                            return
                        }
                        self.errorMessage = error.localizedDescription
                        self.isError = true
                    default:
                        self.onBatchResultCallback?(result)
                    }
                }
            }
        )
    }
    
}

//MARK: - ThreeDS
extension PayViewModel {
    func handleThreeDSResult(_ result: ThreeDSResult) {
        switch initialMode {
        case .single:
            handleThreeDSResultPayment(result)
        case .batch:
            handleThreeDSResultBatchPayment(result)
        }
    }
    
    func handleThreeDSResultPayment(_ result: ThreeDSResult) {
        resetState()
        stopLoader()
        
        switch result {
        case let .success(externalId, paymentId, tokenizedCard, _),
            let .cancelled(externalId, paymentId, tokenizedCard, _):
            startCheckPayment(
                externalId: externalId,
                paymentId: paymentId,
                tokenizedCard: tokenizedCard
            )
        case let .failed(error, tokenizedCard, _):
            guard let externalId = error.externalId,
                  let paymentId = error.paymentId
            else {
                onResultCallback?(
                    .failed(error: error)
                )
                return
            }
            startCheckPayment(
                externalId: externalId,
                paymentId: paymentId,
                tokenizedCard: tokenizedCard
            )
        }
    }
    
 
    
    func handleThreeDSResultBatchPayment(_ result: ThreeDSResult) {
        resetState()
        stopLoader()
        
        switch result {
        case let .success(externalId, _, tokenizedCard, ordersPayments),
            let .cancelled(externalId, _, tokenizedCard, ordersPayments):
            startCheckBatchPayment(
                batchExternalId: externalId,
                tokenizedCard: tokenizedCard,
                ordersPayments: ordersPayments
            )
        case let .failed(error, tokenizedCard, ordersPayments):
            guard let externalId = error.externalId,
                  let ordersPayments = ordersPayments
            else {
                onBatchResultCallback?(
                    .failed(
                        batchExternalId: nil,
                        error: error,
                        ordersPayments: ordersPayments
                    )
                )
                return
            }
            startCheckBatchPayment(
                batchExternalId: externalId,
                tokenizedCard: tokenizedCard,
                ordersPayments: ordersPayments
            )
        }
    }
}
