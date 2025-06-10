//
//  CreateBatchPaymentResult.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 02.06.2025.
//
import Foundation

public typealias CreateBatchPaymentResultCompletionHandler =  (CreateBatchPaymentResult) -> Void

public enum CreateBatchPaymentResult: Error {
    case success(batchExternalId: String, ordersPayments: [BatchOrderPaymentResult])
    case failed(batchExternalId: String, error: PaymentError)
    case confirmation3DsRequired(batchExternalId: String, ordersPayments: [BatchOrderPaymentResult], url: String, callbackUrl: String?)
    case cancelled(batchExternalId: String?)
}
