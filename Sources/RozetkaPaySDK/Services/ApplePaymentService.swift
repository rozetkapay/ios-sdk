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
    private var paymentStatus = PKPaymentAuthorizationStatus.failure
    private var onResultCallback: ApplePaymentCompletionHandler?
    
    private var config: ApplePayConfig
    private var amountParameters: PaymentParameters.AmountParameters
    private let orderId: String
    
    //MARK: - Init
    init?(
        orderId: String,
        config: ApplePayConfig?,
        amount: PaymentParameters.AmountParameters?
    ) {
        guard let config = config,
              let amount = amount
        else {
            return nil
        }
        self.config = config
        self.amountParameters = amount
        self.orderId = orderId
    }
}

//MARK: - Methods
extension ApplePaymentService {
    
    func startPayment(onResultCallback: @escaping ApplePaymentCompletionHandler) {
        let amount = PKPaymentSummaryItem(
            label: Localization.rozetka_pay_payment_applepay_label_amount.description,
            amount: NSDecimalNumber(string: MoneyFormatter.formatCoinsToMoney(coins: amountParameters.amount)),
            type: .final
        )
        paymentSummaryItems.append(amount)
        
        if let _tax = amountParameters.tax.isNilOrEmptyValue {
            let tax = PKPaymentSummaryItem(
                label: Localization.rozetka_pay_payment_applepay_label_tax.description,
                amount: NSDecimalNumber(string: MoneyFormatter.formatCoinsToMoney(coins: _tax)),
                type: .final
            )
            paymentSummaryItems.append(tax)
        }
        let total = PKPaymentSummaryItem(
            label: Localization.rozetka_pay_payment_applepay_label_total.description,
            amount: NSDecimalNumber(string: MoneyFormatter.formatCoinsToMoney(coins: amountParameters.total)),
            type: .pending
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
        self.onResultCallback = onResultCallback
        
        self.paymentController?.present(completion: { (presented: Bool) in
            if presented {
                Logger.payByApplePay.info("✅ Presented Apple Pay payment controller")
            } else {
                Logger.payByApplePay.warning("⚠️ WARNING: Apple Pay payment controller unavailable")
                
                let paymentError = PaymentError(
                    code: ErrorResponseCode.applePayUnavailable.rawValue,
                    message: "Apple Pay payment controller unavailable",
                    orderId: self.orderId,
                    type: ErrorResponseType.paymentError.rawValue
                )
                
                self.onResultCallback?(
                    .failed(error: paymentError)
                )
            }
        })
    }
    
    
    private func createPayToken(from payment: PKPayment) -> String? {
        let paymentData = payment.token.paymentData
        guard
            let jsonObject = try? JSONSerialization.jsonObject(with: paymentData, options: []),
            JSONSerialization.isValidJSONObject(jsonObject),
            let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [])
        else {
            Logger.payByApplePay.error("🔴 ERROR: Failed to parse PKPayment token to JSON")
            return nil
        }
        
        let base64Token = jsonData.base64EncodedString()
        return base64Token
    }
    
}

//MARK: - PKPaymentAuthorizationControllerDelegate
extension ApplePaymentService: PKPaymentAuthorizationControllerDelegate {
    
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        
        guard let tokenBase64 = createPayToken(from: payment) else {
            self.paymentStatus = .failure
            completion(self.paymentStatus)
            
            let errorModel = PaymentError(
                code: ErrorResponseCode.applePayTokenError.rawValue,
                message: "Failed to encode Apple Pay token",
                orderId: self.orderId,
                type: ErrorResponseType.applePayError.rawValue
            )
            Logger.payByApplePay.error("🔴 ERROR: Failed to encode Apple Pay token")
            self.onResultCallback?(
                .failed(error: errorModel)
            )
            return
        }
        
        self.paymentStatus = .success
        
        completion(self.paymentStatus)
        
        Logger.payByApplePay.info("✅ Success: Apple Pay is created")
        self.onResultCallback?(
            .success(orderId: self.orderId, key: tokenBase64)
        )
    }
    
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        
        DispatchQueue.main.async { [weak self] in
            controller.dismiss {
                guard let self = self else {
                    return
                }
                
                switch self.paymentStatus {
                case .success:
                    break
                case .failure:
                    let errorModel = PaymentError(
                        code: ErrorResponseCode.applePayFailed.rawValue,
                        message: "Payment has not been completed",
                        orderId: self.orderId,
                        type: ErrorResponseType.applePayError.rawValue
                    )
                    Logger.payByApplePay.error("🔴 ERROR: Payment has not been completed")
                    self.onResultCallback?(
                        .failed(error: errorModel)
                    )
                default:
                    break
                }
            }
        }
    }
}
