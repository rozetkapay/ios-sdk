//
//  BatchPaymentDetailsResponse.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 05.06.2025.
//


import Foundation
import OSLog

public struct BatchPaymentDetailsResponse: Decodable {
    public let batchExternalId: String
    public let status: String
    public let statusCode: String?
    public let statusDescription: String?
    
    private enum CodingKeys: String, CodingKey {
        case batchExternalId = "batch_external_id"
        case status
        case statusCode = "status_code"
        case statusDescription = "status_description"
    }
 
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.batchExternalId = try container.decode(String.self, forKey: .batchExternalId)
        self.status = try container.decode(String.self, forKey: .status)
        self.statusCode = try container.decode(String.self, forKey: .statusCode)
        self.statusDescription = try container.decodeIfPresent(String.self, forKey: .statusDescription)
    }
}

extension BatchPaymentDetailsResponse {
    func convertToCheckBatchPaymentData(ordersPayments: [BatchOrderPaymentResult]?) -> CheckBatchPaymentData? {
        return CheckBatchPaymentData(
            batchExternalId: self.batchExternalId,
            status: self.convertToStatus(),
            statusCode: self.statusCode,
            statusDescription: self.statusDescription,
            ordersPayments: ordersPayments
        )
    }
    
    func convertToStatus() -> PaymentStatus {
        guard let status = PaymentStatus(rawValue: self.status) else {
            Logger.payServices.error("🔴 ERROR: Unknown payment status: \(self.status)")
            return .failure
        }
        return status
    }
}
