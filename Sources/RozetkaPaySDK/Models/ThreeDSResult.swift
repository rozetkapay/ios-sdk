//
//  ThreeDSResult.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 17.04.2025.
//
import Foundation

typealias ThreeDSCompletionHandler = (ThreeDSResult) -> Void

enum ThreeDSResult {
    case success(externalId: String, paymentId: String?, tokenizedCard: TokenizedCard?, ordersPayments: [BatchOrderPaymentResult]?)
    case failed(error: PaymentError, tokenizedCard: TokenizedCard?, ordersPayments: [BatchOrderPaymentResult]?)
    case cancelled(externalId: String, paymentId: String?, tokenizedCard: TokenizedCard?, ordersPayments: [BatchOrderPaymentResult]?)
}
