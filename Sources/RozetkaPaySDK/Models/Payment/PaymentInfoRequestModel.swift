//
//  PaymentInfoRequestModel.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 14.04.2025.
//
import Foundation

struct CheckPaymentRequestModel: Encodable {
    let orderId: String
    let paymentId: String?
    let externalId: String

    private enum CodingKeys: String, CodingKey {
        case externalId = "external_id"
    }

    init(
        orderId: String,
        paymentId: String?,
        externalId: String
    ) {
        self.orderId = orderId
        self.paymentId = paymentId
        self.externalId = externalId
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.externalId, forKey: .externalId)
    }
}
