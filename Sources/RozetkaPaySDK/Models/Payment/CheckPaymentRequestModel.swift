//
//  CheckPaymentRequestModel.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 14.04.2025.
//
import Foundation

struct CheckPaymentRequestModel: Encodable {
    let paymentId: String?
    let externalId: String
    let tokenizedCard: TokenizedCard?

    private enum CodingKeys: String, CodingKey {
        case externalId = "external_id"
    }

    init(
        externalId: String,
        paymentId: String?,
        tokenizedCard: TokenizedCard?
    ) {
        self.paymentId = paymentId
        self.externalId = externalId
        self.tokenizedCard = tokenizedCard
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.externalId, forKey: .externalId)
    }
}
