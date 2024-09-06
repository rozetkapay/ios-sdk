//
//  PaymentRequest.swift
//
//
//  Created by Ruslan Kasian Dev on 03.09.2024.
//

import Foundation

public protocol PaymentRequest {
    var authParameters: ClientAuthParameters { get }
    var paymentParameters: BasePaymentParameters { get }
}

public struct BasePaymentParameters {
    let amount: Int64
    let currencyCode: String
    let orderId: String
    let callbackUrl: String?
    
    public init(amount: Int64, currencyCode: String, orderId: String, callbackUrl: String? = nil) {
        self.amount = amount
        self.currencyCode = currencyCode
        self.orderId = orderId
        self.callbackUrl = callbackUrl
    }
}

public struct ApplePayPaymentRequest: PaymentRequest {
    public let authParameters: ClientAuthParameters
    public let paymentParameters: BasePaymentParameters
    public let applePayToken: String
    
    public init(authParameters: ClientAuthParameters, paymentParameters: BasePaymentParameters, applePayToken: String) {
        self.authParameters = authParameters
        self.paymentParameters = paymentParameters
        self.applePayToken = applePayToken
    }
}

