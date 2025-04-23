//
//  ThreeDSResult.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 17.04.2025.
//
import Foundation

typealias ThreeDSCompletionHandler = (ThreeDSResult) -> Void

enum ThreeDSResult {
    case success(orderId: String, paymentId: String)
    case failed(error: PaymentError)
    case cancelled(orderId: String, paymentId: String)
}
