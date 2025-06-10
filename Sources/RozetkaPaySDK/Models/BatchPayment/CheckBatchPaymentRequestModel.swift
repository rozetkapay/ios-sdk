//
//  CheckBatchPaymentRequestModel.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 05.06.2025.
//

import Foundation

struct CheckBatchPaymentRequestModel: Encodable {
    let batchExternalId: String
    let tokenizedCard: TokenizedCard?
    let ordersPayments: [BatchOrderPaymentResult]?

    private enum CodingKeys: String, CodingKey {
        case batchExternalId = "batch_external_id"
    }

    init(
        batchExternalId: String,
        tokenizedCard: TokenizedCard?,
        ordersPayments: [BatchOrderPaymentResult]?
    ) {
        self.batchExternalId = batchExternalId
        self.tokenizedCard = tokenizedCard
        self.ordersPayments = ordersPayments
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.batchExternalId, forKey: .batchExternalId)
    }
}
