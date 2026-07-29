//
//  ApplePaymentService.swift
//
//
//  Created by Ruslan Kasian Dev on 31.08.2024.
//

import PassKit
import OSLog

final class ApplePaymentService: NSObject {
    //MARK: - Properties
    private var paymentController: PKPaymentAuthorizationController?
    private var paymentSummaryItems = [PKPaymentSummaryItem]()
    private var onResultCallback: ApplePaymentCompletionHandler?
    private var didAuthorizePayment = false
    private var hasDeliveredResult = false
    
    private var config: ApplePayConfig
    private var amountParameters: AmountParameters
    private let externalId: String
    
    //MARK: - Init
    init?(
        externalId: String,
        config: ApplePayConfig?,
        amount: AmountParameters?
    ) {
        guard let config = config,
              let amount = amount
        else {
            return nil
        }
        self.config = config
        self.amountParameters = amount
        self.externalId = externalId
    }
}

//MARK: - Methods
extension ApplePaymentService {
    
    func startPayment(onResultCallback: @escaping ApplePaymentCompletionHandler) {
        
        self.onResultCallback = onResultCallback
        self.didAuthorizePayment = false
        self.hasDeliveredResult = false

        guard config.checkApplePayAvailability() else {

            let paymentError = PaymentError(
                code: ErrorResponseCode.applePayUnavailable.rawValue,
                message: "Apple Pay is not available on this device.",
                externalId: self.externalId,
                type: ErrorResponseType.paymentError.rawValue
            )

            self.deliver(.failed(error: paymentError))
            return
        }
        
        paymentSummaryItems.removeAll()
        let amount = PKPaymentSummaryItem(
            label: Localization.rozetka_pay_payment_applepay_label_amount.description,
            amount: NSDecimalNumber(string: MoneyFormatter.formatCoinsToRawMoneyString(coins: amountParameters.amount)),
            type: .final
        )
        paymentSummaryItems.append(amount)
        
        if let _tax = amountParameters.tax.isNilOrEmptyValue {
            let tax = PKPaymentSummaryItem(
                label: Localization.rozetka_pay_payment_applepay_label_tax.description,
                amount: NSDecimalNumber(string: MoneyFormatter.formatCoinsToRawMoneyString(coins: _tax)),
                type: .final
            )
            paymentSummaryItems.append(tax)
        }
        let total = PKPaymentSummaryItem(
            label: config.merchantName,
            amount: NSDecimalNumber(string: MoneyFormatter.formatCoinsToRawMoneyString(coins: amountParameters.total)),
            type: .final
        )
        paymentSummaryItems.append(total)
        
        let paymentRequest = PKPaymentRequest()
        paymentRequest.paymentSummaryItems = paymentSummaryItems
        paymentRequest.merchantIdentifier = config.merchantIdentifier
        paymentRequest.merchantCapabilities = config.merchantCapabilities
        paymentRequest.countryCode = config.countryCode
        paymentRequest.currencyCode = config.currencyCode
        paymentRequest.supportedNetworks = config.supportedNetworks
        
        
        self.paymentController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
        self.paymentController?.delegate = self
        
        DispatchQueue.main.async { [weak self] in
            guard let self else {
                return
            }
            self.paymentController?.present { presented in
                if presented {
                    Logger.payByApplePay.info("✅ Presented Apple Pay payment controller")
                } else {
                    Logger.payByApplePay.warning("⚠️ WARNING: Apple Pay payment controller unavailable")
                    
                    let paymentError = PaymentError(
                        code: ErrorResponseCode.applePayUnavailable.rawValue,
                        message: "Apple Pay payment controller unavailable",
                        externalId: self.externalId,
                        type: ErrorResponseType.paymentError.rawValue
                    )

                    self.deliver(.failed(error: paymentError))
                }
            }
        }
    }
    
    
    private func deliver(_ result: ApplePaymentResult) {
        guard !hasDeliveredResult else {
            return
        }
        hasDeliveredResult = true
        onResultCallback?(result)
    }

    private func createPayToken(from payment: PKPayment) -> String? {
        let paymentData = payment.token.paymentData
        
        guard !paymentData.isEmpty else {
            Logger.payByApplePay.error("🔴 ERROR: Apple Pay paymentData is empty. Likely due to testing on Simulator or without valid Wallet setup.")
            return nil
        }
        
        let base64Token = paymentData.base64EncodedString()
        
        guard !base64Token.isEmpty else {
            Logger.payByApplePay.error("🔴 ERROR: Failed to encode Apple Pay token to Base64")
            return nil
        }
        
        Logger.payByApplePay.debug("✅ Apple Pay token successfully encoded: \(base64Token.prefix(5))... to Base64")
        
        return base64Token
    }
    
}

//MARK: - PKPaymentAuthorizationControllerDelegate
extension ApplePaymentService: PKPaymentAuthorizationControllerDelegate {
    
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {

        self.didAuthorizePayment = true

        guard let tokenBase64 = createPayToken(from: payment) else {
            completion(.failure)

            let errorModel = PaymentError(
                code: ErrorResponseCode.applePayTokenError.rawValue,
                message: "Failed to encode Apple Pay token",
                externalId: self.externalId,
                type: ErrorResponseType.applePayError.rawValue
            )
            Logger.payByApplePay.error("🔴 ERROR: Failed to encode Apple Pay token")
            self.deliver(.failed(error: errorModel))
            return
        }

        completion(.success)

        Logger.payByApplePay.info("✅ Success: Apple Pay is created")
        self.deliver(
            .success(
                externalId: self.externalId,
                key: tokenBase64
            )
        )
    }

    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {

        DispatchQueue.main.async { [weak self] in
            controller.dismiss {
                guard let self = self else {
                    return
                }

                self.paymentController = nil

                if !self.didAuthorizePayment {
                    Logger.payByApplePay.info("ℹ️ Apple Pay sheet was dismissed without authorization, externalId: \(self.externalId)")
                    self.deliver(.dismissed(externalId: self.externalId))
                }
            }
        }
    }
}
