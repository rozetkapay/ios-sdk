//
//  File.swift
//
//
//  Created by Ruslan Kasian Dev on 29.08.2024.
//
import SwiftUI
import PassKit

@MainActor
final class PayViewModel:  BaseViewModel {
    
    //MARK: - Constants & Defaults
    
    private enum Constants {
        static let vStackSpacing: CGFloat = 16
    }
    
    //MARK: - Enums
    
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

    private var lastError: PaymentError?
    
    private let amountWithCurrencyStr: String
    
    @Published var isThreeDSConfirmationPresented = false
    private var threeDSModel: ThreeDSRequest?
    
    private let onResultCallback: PaymentResultCompletionHandler?
    private let onBatchResultCallback: BatchPaymentResultCompletionHandler?
    private var hasDeliveredResult = false
    
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
        self.resultUrl = parameters.resultUrl
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
            provideCardPaymentSystemUseCase: provideCardPaymentSystemUseCase ?? ProvideCardPaymentSystemUseCase(),
            errorDismissButtonTitle: parameters.errorDismissButtonTitle
        )
        
        checkIsNeedToPayByTokenizedCard()
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
            provideCardPaymentSystemUseCase: provideCardPaymentSystemUseCase ?? ProvideCardPaymentSystemUseCase(),
            errorDismissButtonTitle: parameters.errorDismissButtonTitle
        )
        
        checkIsNeedToPayByTokenizedCard()
        setTestData()
    }
}

//MARK: - Methods
extension PayViewModel {
    
    func getVStackSpacing() -> CGFloat {
        return Constants.vStackSpacing
    }
    
    func getIsAllowApplePay() -> Bool {
        return isAllowApplePay
    }
    
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
        stopLoader()
        clearError()
        isThreeDSConfirmationPresented = false
        threeDSModel = nil

        switch initialMode {
        case .single:
            deliver(
                .cancelled(
                    externalId: externalId,
                    paymentId: nil
                )
            )
        case .batch:
            deliverBatch(
                .cancelled(
                    batchExternalId: externalId
                )
            )
        }
    }

    func failed() {
        stopLoader()
        clearError()
        isThreeDSConfirmationPresented = false
        threeDSModel = nil

        let error = lastError ?? PaymentError(
            code: nil,
            message: errorMessage,
            externalId: externalId
        )

        switch initialMode {
        case .single:
            deliver(
                .failed(error: error)
            )
        case .batch:
            deliverBatch(
                .failed(
                    batchExternalId: externalId,
                    error: error,
                    ordersPayments: nil
                )
            )
        }
    }

    func handleViewDisappeared() {
        guard !hasDeliveredResult else { return }
        cancelled()
    }

    private func deliver(_ result: PaymentResult) {
        guard !hasDeliveredResult else { return }
        hasDeliveredResult = true
        onResultCallback?(result)
    }

    private func deliverBatch(_ result: BatchPaymentResult) {
        guard !hasDeliveredResult else { return }
        hasDeliveredResult = true
        onBatchResultCallback?(result)
    }
    
    func retryLoading() {
        switch initialPaymentType {
        case .singleToken:
            self.startPayByTokenizedCard()
        default:
            resetState()
            initialPaymentType = .unknown
        }
    }
    
    func resetState() {
        clearError()
        isThreeDSConfirmationPresented = false
        threeDSModel = nil
    }
}

//MARK: - Private Methods
private extension PayViewModel {
    
    func buildPaymentModel(paymentMethod: PaymentMethod) -> PaymentRequestModel {
        return PaymentRequestModel(
            amountInCoins: self.amountParameters.total,
            currency: self.amountParameters.currencyCode,
            externalId: self.externalId,
            callbackUrl: self.callbackUrl,
            resultUrl: self.resultUrl,
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
    
   private func checkIsNeedToPayByTokenizedCard() {
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
            Task { @MainActor in
                guard let self else { return }
                switch result {
                case let .success(_, token):
                    self.createPayment(fromApplePay: token)
                case let .cancelled(externalId):
                    self.handlePrePaymentCancelled(externalId: externalId)
                case let .failed(error):
                    self.handlePrePaymentFailed(error)
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
                Task { @MainActor in
                    guard let self else { return }
                    switch result {
                    case .complete(let successModel):
                        self.createPayment(from: successModel)
                    case .failed(let error):
                        self.handleTokenizationFailed(error)
                    case .cancelled:
                        self.handlePrePaymentCancelled(externalId: self.externalId)
                    }
                }
            }
        )
    }
    
}

//MARK: - PayByCard
private extension PayViewModel {
    func showError(_ message: String?) {
        setError(message)
        isThreeDSConfirmationPresented = false
        threeDSModel = nil
    }

    func showError(_ error: PaymentError) {
        lastError = error
        showError(error.localizedDescription)
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
                    Task { @MainActor in
                        guard let self else { return }
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
                    Task { @MainActor in
                        guard let self else { return }
                        self.processBatchPaymentResult(result, tokenizedCard)
                    }
                }
            )
        }
    }
    
    func handlePrePaymentCancelled(externalId: String?) {
        switch initialMode {
        case .single:
            processPaymentResult(
                .cancelled(externalId: externalId, paymentId: nil)
            )
        case .batch:
            processBatchPaymentResult(
                .cancelled(batchExternalId: externalId)
            )
        }
    }

    func handlePrePaymentFailed(_ error: PaymentError) {
        switch initialMode {
        case .single:
            processPaymentResult(
                .failed(error: error)
            )
        case .batch:
            processBatchPaymentResult(
                .failed(
                    batchExternalId: externalId,
                    error: error
                )
            )
        }
    }

    func handleTokenizationFailed(_ error: TokenizationError) {
        switch initialMode {
        case .single:
            processPaymentResult(
                error.convertToCreatePaymentResult(externalId)
            )
        case .batch:
            processBatchPaymentResult(
                error.convertToCreateBatchPaymentResult(externalId)
            )
        }
    }

    func processPaymentResult(_ result: CreatePaymentResult, _ tokenizedCard: TokenizedCard? = nil) {
        resetState()
        stopLoader()

        switch result {
        case let .cancelled(externalId, paymentId):
            deliver(
                .cancelled(
                    externalId: externalId,
                    paymentId: paymentId
                )
            )
        case let .success(externalId, paymentId):
            deliver(
                .complete(
                    externalId: externalId,
                    paymentId: paymentId,
                    tokenizedCard: tokenizedCard
                )
            )
        case let .confirmation3DsRequired(externalId, paymentId, url, callbackUrl):
            threeDSModel = ThreeDSRequest(
                externalId: externalId,
                acsUrl: url,
                termUrl: callbackUrl,
                paymentId: paymentId,
                tokenizedCard: tokenizedCard
            )
            isThreeDSConfirmationPresented = true
            clearError()
        case let .failed(error):
            if error.code == .transactionAlreadyPaid {
                deliver(.failed(error: error))
                return
            }
            showError(error)
        }
    }

    func processBatchPaymentResult(_ result: CreateBatchPaymentResult, _ tokenizedCard: TokenizedCard? = nil) {
        resetState()
        stopLoader()

        switch result {
        case let .cancelled(batchExternalId):
            deliverBatch(.cancelled(batchExternalId: batchExternalId))
        case let .success(batchExternalId, ordersPayments):
            deliverBatch(
                .complete(
                    batchExternalId: batchExternalId,
                    ordersPayments: ordersPayments,
                    tokenizedCard: tokenizedCard
                )
            )
        case let .confirmation3DsRequired(batchExternalId, ordersPayments, url, callbackUrl):
            threeDSModel = ThreeDSRequest(
                externalId: batchExternalId,
                acsUrl: url,
                termUrl: callbackUrl,
                tokenizedCard: tokenizedCard,
                ordersPayments: ordersPayments
            )

            isThreeDSConfirmationPresented = true
            clearError()
        case let .failed(batchExternalId, error):
            if error.code == .transactionAlreadyPaid {
                deliverBatch(
                    .failed(
                        batchExternalId: batchExternalId,
                        error: error,
                        ordersPayments: nil
                    )
                )
                return
            }
            showError(error)
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
                Task { @MainActor in
                    guard let self else { return }
                    self.stopLoader()
                    switch result {
                    case let .failed(error):
                        if error.code == .transactionAlreadyPaid {
                            self.deliver(.failed(error: error))
                            return
                        }
                        self.showError(error)
                    default:
                        self.deliver(result)
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
                Task { @MainActor in
                    guard let self else { return }
                    self.stopLoader()
                    switch result {
                    case let .failed(batchExternalId, error, ordersPayments):
                        if error.code == .transactionAlreadyPaid {
                            self.deliverBatch(
                                .failed(
                                    batchExternalId: batchExternalId,
                                    error: error,
                                    ordersPayments: ordersPayments
                                )
                            )
                            return
                        }
                        self.showError(error)
                    default:
                        self.deliverBatch(result)
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
                deliver(
                    .failed(
                        error: error
                    )
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
                deliverBatch(
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
