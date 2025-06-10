//
//  BatchOrderPaymentResult.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 03.06.2025.
//
import Foundation

public struct BatchOrderPaymentResult {
    public let externalId: String
    public let operationId: String
    public let status: PaymentStatus
}
