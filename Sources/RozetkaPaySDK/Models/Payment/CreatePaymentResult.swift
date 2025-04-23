//
//  CreatePaymentResult.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 15.04.2025.
//
import Foundation

public typealias CreatePaymentResultCompletionHandler =  (CreatePaymentResult) -> Void

public enum CreatePaymentResult: Error {
    case success(orderId: String, paymentId: String)
    case failed(error: PaymentError)
    case confirmation3DsRequired(orderId: String, paymentId: String, url: String, callbackUrl: String?)
    case cancelled(orderId: String?, paymentId: String?)
}
