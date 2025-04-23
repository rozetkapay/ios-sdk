//
//  PaymentDetailsResponse.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 16.04.2025.
//


import Foundation

public struct PaymentDetailsResponse: Decodable {
    let purchaseDetails: [PaymentResultDetails]
    let receiptUrl: String?
    let externalId: String
    
    private enum CodingKeys: String, CodingKey {
        case purchaseDetails = "purchase_details"
        case receiptUrl = "receipt_url"
        case externalId = "external_id"
    }
 
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.purchaseDetails = try container.decode([PaymentResultDetails].self, forKey: .purchaseDetails)
        self.receiptUrl = try container.decodeIfPresent(String.self, forKey: .receiptUrl)
        self.externalId = try container.decode(String.self, forKey: .externalId)
    }
}

extension PaymentDetailsResponse {

    func convertToCheckPaymentData(paymentId: String?) -> CheckPaymentData? {
        guard let paymentId else {
            return nil
        }
        guard let value =  self.purchaseDetails.first(where: { $0.paymentId == paymentId }) else {
            return nil
        }
        return CheckPaymentData(
            externalId: self.externalId,
            paymentId: value.paymentId,
            status: value.convertToStatus(),
            statusCode: value.statusCode,
            statusDescription: value.statusDescription
        )
    }
}
