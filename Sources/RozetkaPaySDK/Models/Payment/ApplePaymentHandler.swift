//
//  ApplePaymentHandler.swift
//
//
//  Created by Ruslan Kasian Dev on 31.08.2024.
//

import PassKit

 typealias ApplePaymentCompletionHandler = (Bool) -> Void

 class ApplePaymentHandler: NSObject {
    
    var paymentController: PKPaymentAuthorizationController?
    var paymentSummaryItems = [PKPaymentSummaryItem]()
    var paymentStatus = PKPaymentAuthorizationStatus.failure
    var completionHandler: ApplePaymentCompletionHandler?
    
     private var config: ApplePayConfig
     private var amountParameters: PaymentParameters.AmountParameters
     
     init?(
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
     }
     
     
    func startPayment(completion: @escaping ApplePaymentCompletionHandler) {
        
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
        
       
        
        // Create our payment request 
        let paymentRequest = PKPaymentRequest()
        paymentRequest.paymentSummaryItems = paymentSummaryItems
        paymentRequest.merchantIdentifier = config.merchantIdentifier
        paymentRequest.merchantCapabilities = config.merchantCapabilities
        paymentRequest.countryCode = config.countryCode
        paymentRequest.currencyCode = config.currencyCode
        paymentRequest.supportedNetworks = config.supportedNetworks
        
        // Display our payment request
        paymentController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
        paymentController?.delegate = self
        completionHandler = completion
        
        paymentController?.present(completion: { (presented: Bool) in
            if presented {
                NSLog("Presented payment controller")
            } else {
                NSLog("Failed to present payment controller")
                self.completionHandler?(false)
            }
        })
    }
}


extension ApplePaymentHandler: PKPaymentAuthorizationControllerDelegate {
    
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        
        // Perform some very basic validation on the provided contact information
        if payment.shippingContact?.emailAddress == nil || payment.shippingContact?.phoneNumber == nil {
            paymentStatus = .failure
        } else {
            // Here you would send the payment token to your server or payment provider to process
            // Once processed, return an appropriate status in the completion handler (success, failure, etc)
            paymentStatus = .success
        }
        
        completion(paymentStatus)
    }
    
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                if self.paymentStatus == .success {
                    self.completionHandler!(true)
                } else {
                    self.completionHandler!(false)
                }
            }
        }
    }
    
}
