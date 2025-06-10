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
    let externalId: String
    let callbackUrl: String?
    
    public init(
        amount: Int64,
        currencyCode: String,
        externalId: String,
        callbackUrl: String? = nil
    ) {
        self.amount = amount
        self.currencyCode = currencyCode
        self.externalId = externalId
        self.callbackUrl = callbackUrl
    }
}

public struct ApplePayPaymentRequest: PaymentRequest {
    public let authParameters: ClientAuthParameters
    public let paymentParameters: BasePaymentParameters
    public let applePayToken: String
    
    public init(
        authParameters: ClientAuthParameters,
        paymentParameters: BasePaymentParameters,
        applePayToken: String
    ) {
        self.authParameters = authParameters
        self.paymentParameters = paymentParameters
        self.applePayToken = applePayToken
    }
}

public struct CardPayPaymentRequest: PaymentRequest {
    public let authParameters: ClientAuthParameters
    public let paymentParameters: BasePaymentParameters
    
    public init(
        authParameters: ClientAuthParameters,
        paymentParameters: BasePaymentParameters
    ) {
        self.authParameters = authParameters
        self.paymentParameters = paymentParameters
    }
}
