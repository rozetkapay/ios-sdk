//
//  BatchPaymentResult.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 03.06.2025.
//
import Foundation

public typealias BatchPaymentResultCompletionHandler =  (BatchPaymentResult) -> Void

public enum BatchPaymentResult: Error {
    case pending(batchExternalId: String, ordersPayments: [BatchOrderPaymentResult]?, message: String?, error: PaymentError?)
    case complete(batchExternalId: String, ordersPayments: [BatchOrderPaymentResult]?, tokenizedCard: TokenizedCard?)
    case failed(batchExternalId: String?, error: PaymentError, ordersPayments: [BatchOrderPaymentResult]?)
    case cancelled(batchExternalId: String?)
}
