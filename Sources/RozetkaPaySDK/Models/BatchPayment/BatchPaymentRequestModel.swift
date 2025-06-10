//
//  BatchPaymentRequestModel.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 30.05.2025.
//
import Foundation

struct BatchPaymentRequestModel: Encodable {
    let currency: String
    let batchExternalId: String
    let callbackUrl: String?
    let resultUrl: String?
    let mode: String
    let customer: Customer
    let orders: [BatchOrder]
    
    private enum CodingKeys: String, CodingKey {
        case currency = "currency"
        case batchExternalId = "batch_external_id"
        case callbackUrl = "callback_url"
        case resultUrl = "result_url"
        case mode
        case customer
        case orders
    }

    init(
        currency: String,
        batchExternalId: String,
        resultUrl: String? = nil,
        callbackUrl: String? = nil,
        mode: String = PaymentApiConstants.modeDirect,
        customer: Customer,
        orders: [BatchOrder]
    ) {
        self.currency = currency
        self.batchExternalId = batchExternalId
        self.resultUrl = resultUrl
        self.callbackUrl = callbackUrl
        self.mode = mode
        self.customer = customer
        self.orders = orders
    }
}
