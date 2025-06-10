//
//  CreatePaymentResult.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 15.04.2025.
//
import Foundation

public typealias CreatePaymentResultCompletionHandler =  (CreatePaymentResult) -> Void

public enum CreatePaymentResult: Error {
    case success(externalId: String, paymentId: String)
    case failed(error: PaymentError)
    case confirmation3DsRequired(externalId: String, paymentId: String, url: String, callbackUrl: String?)
    case cancelled(externalId: String?, paymentId: String?)
}
