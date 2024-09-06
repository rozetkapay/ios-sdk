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
     
     init?(config: ApplePayConfig?) {
         guard let config = config else {
             return nil
         }
         self.config = config
     }
     
     
    func startPayment(completion: @escaping ApplePaymentCompletionHandler) {
        
        let amount = PKPaymentSummaryItem(label: "Amount", amount: NSDecimalNumber(string: "8.88"), type: .final)
        let tax = PKPaymentSummaryItem(label: "Tax", amount: NSDecimalNumber(string: "1.12"), type: .final)
        let total = PKPaymentSummaryItem(label: "ToTal", amount: NSDecimalNumber(string: "10.00"), type: .pending)
        
        paymentSummaryItems = [amount, tax, total];
        completionHandler = completion
        
        // Create our payment request 
        let paymentRequest = PKPaymentRequest()
        paymentRequest.paymentSummaryItems = paymentSummaryItems
        paymentRequest.merchantIdentifier = config.merchantIdentifier
        paymentRequest.merchantCapabilities = config.merchantCapabilities
        paymentRequest.countryCode = "US"
        paymentRequest.currencyCode = "USD"
        paymentRequest.requiredShippingContactFields = [.phoneNumber, .emailAddress]
        paymentRequest.supportedNetworks = config.supportedNetworks
        
        // Display our payment request
        paymentController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
        paymentController?.delegate = self
        
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
