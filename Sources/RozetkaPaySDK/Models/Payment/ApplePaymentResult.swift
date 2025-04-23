//
//  ApplePaymentResult.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 23.04.2025.
//

typealias ApplePaymentCompletionHandler = (ApplePaymentResult) -> Void

enum ApplePaymentResult {
    case success(orderId: String, key: String)
    case failed(error: PaymentError)
    case cancelled(orderId: String)
}
