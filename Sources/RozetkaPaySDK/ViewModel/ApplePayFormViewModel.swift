//
//  ApplePayFormViewModel.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 03.07.2026.
//
import SwiftUI
import PassKit
import OSLog

@MainActor
final class ApplePayFormViewModel: BaseViewModel {

    //MARK: - Enums
    private enum InitialPaymentMode {
        case single
        case batch
    }

    //MARK: - Properties
    private let initialMode: InitialPaymentMode
    private let applePaymentService: ApplePaymentService?
    private let amountParameters: AmountParameters
    private let externalId: String
    private let callbackUrl: String?
    private let resultUrl: String?
    private let batchOrders: [BatchOrder]?

    /// Computed once at init: whether the device supports Apple Pay with the given config.
    let isApplePayAvailable: Bool

    /// Label rendered on the Apple Pay button, taken from `ApplePayConfig.buttonType`.
    let applePayButtonType: PKPaymentButtonType

    /// When `true`, dismissing the Apple Pay sheet without paying delivers a terminal
    /// `.cancelled` result instead of only stopping the loader.
    ///
    /// `ApplePayFormView` keeps this `false`: its button stays on screen, so the user
    /// can simply tap it again. The imperative flow
    /// (`RozetkaPaySdk.payByApplePay`) has no button left to tap and its host waits
    /// for exactly one terminal result, so it needs the `.cancelled` event.
    private let deliversCancelledOnSheetDismiss: Bool

    @Published var isThreeDSConfirmationPresented = false
    private var threeDSModel: ThreeDSRequest?

    private let onResultCallback: PaymentResultCompletionHandler?
    private let onBatchResultCallback: BatchPaymentResultCompletionHandler?
    private let stateUICallback: ApplePayFormUIStateCompletionHandler?

    //MARK: - Inits
    init(
        parameters: ApplePayFormParameters,
        onResultCallback: @escaping PaymentResultCompletionHandler,
        stateUICallback: @escaping ApplePayFormUIStateCompletionHandler,
        deliversCancelledOnSheetDismiss: Bool = false
    ) {
        self.initialMode = .single
        self.deliversCancelledOnSheetDismiss = deliversCancelledOnSheetDismiss
        self.amountParameters = parameters.amountParameters
        self.externalId = parameters.externalId
        self.callbackUrl = parameters.callbackUrl
        self.resultUrl = parameters.resultUrl
        self.applePaymentService = parameters.applePaymentService
        self.isApplePayAvailable = parameters.applePayConfig.checkApplePayAvailability()
        self.applePayButtonType = parameters.applePayConfig.buttonType
        self.batchOrders = nil

        self.onResultCallback = onResultCallback
        self.onBatchResultCallback = nil
        self.stateUICallback = stateUICallback

        super.init(
            client: parameters.client,
            viewParameters: parameters.viewParameters,
            themeConfigurator: parameters.themeConfigurator,
            provideCardPaymentSystemUseCase: ProvideCardPaymentSystemUseCase()
        )
    }

    init(
        parameters: BatchApplePayFormParameters,
        onResultCallback: @escaping BatchPaymentResultCompletionHandler,
        stateUICallback: @escaping ApplePayFormUIStateCompletionHandler,
        deliversCancelledOnSheetDismiss: Bool = false
    ) {
        self.initialMode = .batch
        self.deliversCancelledOnSheetDismiss = deliversCancelledOnSheetDismiss
        self.amountParameters = parameters.amountParameters
        self.externalId = parameters.externalId
        self.callbackUrl = parameters.callbackUrl
        self.resultUrl = parameters.resultUrl
        self.applePaymentService = parameters.applePaymentService
        self.isApplePayAvailable = parameters.applePayConfig.checkApplePayAvailability()
        self.applePayButtonType = parameters.applePayConfig.buttonType
        self.batchOrders = parameters.orders

        self.onResultCallback = nil
        self.onBatchResultCallback = onResultCallback
        self.stateUICallback = stateUICallback

        super.init(
            client: parameters.client,
            viewParameters: parameters.viewParameters,
            themeConfigurator: parameters.themeConfigurator,
            provideCardPaymentSystemUseCase: ProvideCardPaymentSystemUseCase()
        )
    }
}

//MARK: - Methods
extension ApplePayFormViewModel {

    func getThreeDSModel() -> ThreeDSRequest? {
        return threeDSModel
    }

    func startPayByApplePay() {
        guard !isLoading else {
            return
        }

        guard let appleService = self.applePaymentService else {
            let paymentError = PaymentError(
                code: ErrorResponseCode.applePayUnavailable.rawValue,
                message: "Apple Pay is not available on this device.",
                externalId: self.externalId,
                type: ErrorResponseType.paymentError.rawValue
            )
            deliverFailed(paymentError)
            return
        }

        resetState()
        startLoader()
        stateUICallback?(.startLoading)

        appleService.startPayment { [weak self] result in
            Task { @MainActor in
                guard let self else { return }
                switch result {
                case let .success(_, token):
                    self.createPayment(fromApplePay: token)
                case let .dismissed(externalId):
                    self.handleApplePaySheetDismissed(externalId: externalId)
                case let .failed(error):
                    self.deliverFailed(error)
                }
            }
        }
    }

    func resetState() {
        clearError()
        isThreeDSConfirmationPresented = false
        threeDSModel = nil
    }
}

//MARK: - Private Methods
private extension ApplePayFormViewModel {

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

    func createPayment(fromApplePay token: String) {
        let method: PaymentMethod = .applePay(
            ApplePay(token: token)
        )

        switch initialMode {
        case .single:
            let payModel = buildPaymentModel(paymentMethod: method)

            PayService.createPayment(
                key: self.client.key,
                model: payModel,
                result: { [weak self] result in
                    Task { @MainActor in
                        guard let self else { return }
                        self.processPaymentResult(result)
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
                        self.processBatchPaymentResult(result)
                    }
                }
            )
        }
    }

    func processPaymentResult(_ result: CreatePaymentResult) {
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
                    tokenizedCard: nil
                )
            )
        case let .confirmation3DsRequired(externalId, paymentId, url, callbackUrl):
            presentThreeDS(
                ThreeDSRequest(
                    externalId: externalId,
                    acsUrl: url,
                    termUrl: callbackUrl,
                    paymentId: paymentId
                )
            )
        case let .failed(error):
            deliver(.failed(error: error))
        }
    }

    func processBatchPaymentResult(_ result: CreateBatchPaymentResult) {
        switch result {
        case let .cancelled(batchExternalId):
            deliverBatch(
                .cancelled(batchExternalId: batchExternalId)
            )
        case let .success(batchExternalId, ordersPayments):
            deliverBatch(
                .complete(
                    batchExternalId: batchExternalId,
                    ordersPayments: ordersPayments,
                    tokenizedCard: nil
                )
            )
        case let .confirmation3DsRequired(batchExternalId, ordersPayments, url, callbackUrl):
            presentThreeDS(
                ThreeDSRequest(
                    externalId: batchExternalId,
                    acsUrl: url,
                    termUrl: callbackUrl,
                    ordersPayments: ordersPayments
                )
            )
        case let .failed(batchExternalId, error):
            deliverBatch(
                .failed(
                    batchExternalId: batchExternalId,
                    error: error,
                    ordersPayments: nil
                )
            )
        }
    }

    func presentThreeDS(_ request: ThreeDSRequest) {
        stopLoader()
        stateUICallback?(.stopLoading)
        clearError()

        threeDSModel = request
        isThreeDSConfirmationPresented = true
    }

    /// Routes an Apple Pay sheet failure to the terminal callback of the active mode.
    func deliverFailed(_ error: PaymentError) {
        switch initialMode {
        case .single:
            deliver(.failed(error: error))
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

    func handleApplePaySheetDismissed(externalId: String) {
        Logger.payByApplePay.info("ℹ️ Returning to the host screen after Apple Pay sheet dismissal, externalId: \(externalId)")

        guard deliversCancelledOnSheetDismiss else {
            stopLoader()
            stateUICallback?(.stopLoading)
            resetState()
            return
        }

        deliverCancelled(externalId: externalId)
    }

    /// Routes an Apple Pay sheet cancellation to the terminal callback of the active mode.
    func deliverCancelled(externalId: String?) {
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
                .cancelled(batchExternalId: externalId)
            )
        }
    }

    /// Delivers a terminal result: streams the matching UI state to the host
    /// (`.error` instead of showing the SDK error screen) and fires the result callback.
    func deliver(_ result: PaymentResult) {
        resetState()
        stopLoader()
        stateUICallback?(.stopLoading)

        switch result {
        case .complete:
            stateUICallback?(.success)
        case let .failed(error):
            stateUICallback?(.error(error.localizedDescription))
        default:
            break
        }

        onResultCallback?(result)
    }

    /// Batch-mode counterpart of `deliver(_:)`.
    func deliverBatch(_ result: BatchPaymentResult) {
        resetState()
        stopLoader()
        stateUICallback?(.stopLoading)

        switch result {
        case .complete:
            stateUICallback?(.success)
        case let .failed(_, error, _):
            stateUICallback?(.error(error.localizedDescription))
        default:
            break
        }

        onBatchResultCallback?(result)
    }
}

//MARK: - CheckPayment
private extension ApplePayFormViewModel {

    func startCheckPayment(
        externalId: String?,
        paymentId: String?
    ) {
        guard let externalId = externalId else {
            return
        }

        resetState()
        startLoader()
        stateUICallback?(.startLoading)

        let model = CheckPaymentRequestModel(
            externalId: externalId,
            paymentId: paymentId,
            tokenizedCard: nil
        )

        PayService.checkPayment(
            key: client.key,
            model: model,
            result: { [weak self] result in
                Task { @MainActor in
                    guard let self else { return }
                    self.deliver(result)
                }
            }
        )
    }

    func startCheckBatchPayment(
        batchExternalId: String?,
        ordersPayments: [BatchOrderPaymentResult]?
    ) {
        guard let batchExternalId = batchExternalId else {
            return
        }

        resetState()
        startLoader()
        stateUICallback?(.startLoading)

        let model = CheckBatchPaymentRequestModel(
            batchExternalId: batchExternalId,
            tokenizedCard: nil,
            ordersPayments: ordersPayments
        )

        BatchPayService.checkBatchPayment(
            key: client.key,
            model: model,
            result: { [weak self] result in
                Task { @MainActor in
                    guard let self else { return }
                    self.deliverBatch(result)
                }
            }
        )
    }
}

//MARK: - ThreeDS
extension ApplePayFormViewModel {

    func handleThreeDSResult(_ result: ThreeDSResult) {
        switch initialMode {
        case .single:
            handleThreeDSResultPayment(result)
        case .batch:
            handleThreeDSResultBatchPayment(result)
        }
    }
}

private extension ApplePayFormViewModel {

    func handleThreeDSResultPayment(_ result: ThreeDSResult) {
        resetState()
        stopLoader()

        switch result {
        case let .success(externalId, paymentId, _, _),
            let .cancelled(externalId, paymentId, _, _):
            startCheckPayment(
                externalId: externalId,
                paymentId: paymentId
            )
        case let .failed(error, _, _):
            guard let externalId = error.externalId,
                  let paymentId = error.paymentId
            else {
                deliver(.failed(error: error))
                return
            }
            startCheckPayment(
                externalId: externalId,
                paymentId: paymentId
            )
        }
    }

    func handleThreeDSResultBatchPayment(_ result: ThreeDSResult) {
        resetState()
        stopLoader()

        switch result {
        case let .success(externalId, _, _, ordersPayments),
            let .cancelled(externalId, _, _, ordersPayments):
            startCheckBatchPayment(
                batchExternalId: externalId,
                ordersPayments: ordersPayments
            )
        case let .failed(error, _, ordersPayments):
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
                ordersPayments: ordersPayments
            )
        }
    }
}
