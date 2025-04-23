//
//  CreatePaymentData.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 16.04.2025.
//
import Foundation

public struct CreatePaymentData {
    let action: Action?
    let paymentId: String
    let status: PaymentStatus
    let statusCode: String?
    let statusDescription: String?

    enum Action {
        case undefined(name: String?, value: String?)
        case confirm3Ds(url: String)
    }
}
