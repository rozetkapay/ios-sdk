//
//  CreateBatchPaymentData.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 05.06.2025.
//
import Foundation

public struct CreateBatchPaymentData {
    let action: Action?
    let batchExternalId: String
    let ordersPayments: [BatchOrderPaymentResult]
    let externalId: String?
    let operationId: String?
    let transactionId: String?
    let status: PaymentStatus
    let statusCode: String?
    let statusDescription: String?

    enum Action {
        case undefined(name: String?, value: String?)
        case confirm3Ds(url: String)
    }
}
