//
//  BatchPaymentDetailsResponse.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 05.06.2025.
//


import Foundation
import OSLog

public struct BatchPaymentDetailsResponse: Decodable {
    let batchExternalId: String
    let status: String
    let statusCode: String?
    let statusDescription: String?
    let statusDescriptionEn: String?
    let statusDescriptionUk: String?
    
    private enum CodingKeys: String, CodingKey {
        case batchExternalId = "batch_external_id"
        case status
        case statusCode = "status_code"
        case statusDescription = "status_description"
        case statusDescriptionEn = "status_description_en"
        case statusDescriptionUk = "status_description_uk"
    }
 
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.batchExternalId = try container.decode(String.self, forKey: .batchExternalId)
        self.status = try container.decode(String.self, forKey: .status)
        self.statusCode = try container.decodeIfPresent(String.self, forKey: .statusCode)
        self.statusDescription = try container.decodeIfPresent(String.self, forKey: .statusDescription)
        self.statusDescriptionEn = try container.decodeIfPresent(String.self, forKey: .statusDescriptionEn)
        self.statusDescriptionUk = try container.decodeIfPresent(String.self, forKey: .statusDescriptionUk)
    }
}

extension BatchPaymentDetailsResponse: LocalizedStatusDescription {}

extension BatchPaymentDetailsResponse {
    func convertToCheckBatchPaymentData(
        ordersPayments: [BatchOrderPaymentResult]?,
        language: RozetkaPayLanguage
    ) -> CheckBatchPaymentData? {
        return CheckBatchPaymentData(
            batchExternalId: self.batchExternalId,
            status: self.convertToStatus(),
            statusCode: self.statusCode,
            statusDescription: self.resolveDescription(language: language),
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
