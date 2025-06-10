//
//  CheckBatchPaymentData.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 05.06.2025.
//
import Foundation

public struct CheckBatchPaymentData {
    let batchExternalId: String
    let status: PaymentStatus
    let statusCode: String?
    let statusDescription: String?
    let ordersPayments: [BatchOrderPaymentResult]?
}
