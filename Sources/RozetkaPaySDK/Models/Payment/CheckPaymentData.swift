//
//  CheckPaymentData.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 16.04.2025.
//
import Foundation

public struct CheckPaymentData {
    let externalId: String
    let paymentId: String
    let status: PaymentStatus
    let statusCode: String?
    let statusDescription: String?
}
