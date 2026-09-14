//
//  CreateBatchPaymentResponse.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 30.05.2025.
//

import Foundation
import OSLog

public struct CreateBatchPaymentResponse: Decodable {
    let action: BatchPaymentResultAction?
    let details: BatchPaymentResultDetails
    let orderDetails: [BatchPaymentOrderResultDetails]
    let receiptUrl: String?
    let batchExternalId: String
    
    private enum CodingKeys: String, CodingKey {
        case action
        case details = "batch_details"
        case receiptUrl = "receipt_url"
        case orderDetails = "orders_details"
        case batchExternalId = "batch_external_id"
    }
 
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.action = try container.decodeIfPresent(BatchPaymentResultAction.self, forKey: .action)
        self.details = try container.decode(BatchPaymentResultDetails.self, forKey: .details)
        self.receiptUrl = try container.decodeIfPresent(String.self, forKey: .receiptUrl)
        self.orderDetails = try container.decode([BatchPaymentOrderResultDetails].self, forKey: .orderDetails)
        self.batchExternalId = try container.decode(String.self, forKey: .batchExternalId)
    }
}

extension CreateBatchPaymentResponse {
    func convertToCreateBatchPaymentData(language: RozetkaPayLanguage) -> CreateBatchPaymentData {
        return CreateBatchPaymentData(
            action: self.action?.convertToAction(),
            batchExternalId: self.batchExternalId,
            ordersPayments: self.orderDetails.mapToBatchOrderPaymentResult(),
            externalId: self.orderDetails.first?.externalId,
            operationId: self.orderDetails.first?.operationId,
            transactionId: self.orderDetails.first?.transactionId,
            status: self.orderDetails.first?.convertToStatus() ?? .failure,
            statusCode: self.orderDetails.first?.statusCode,
            statusDescription: self.orderDetails.first?.resolveDescription(language: language)
        )
    }
}

//MARK: - Action
public struct BatchPaymentResultAction: Decodable {
    let type: String?
    let value: String?
    
    private enum CodingKeys: String, CodingKey {
        case type
        case value
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.value = try container.decodeIfPresent(String.self, forKey: .value)
    }
}

extension BatchPaymentResultAction {
    func convertToAction() -> CreateBatchPaymentData.Action {
        switch type {
        case "url":
            guard let value = self.value else {
                return .undefined(name: self.type, value: self.value)
            }
            return .confirm3Ds(url: value)
        default:
            return .undefined(name: type, value: value)
        }
    }
}

//MARK: - Result
public struct BatchPaymentResultDetails: Decodable {
    let amount: Int64
    let currency: String

       enum CodingKeys: String, CodingKey {
           case amount
           case currency
       }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let value = try? container.decode(Double.self, forKey: .amount) {
            self.amount = value.convertToCoinsAmount()
        }else if let value = try? container.decode(Int64.self, forKey: .amount) {
            self.amount = value.convertToCoinsAmount()
        }else if let value = try? container.decode(String.self, forKey: .amount).amount() {
            self.amount = value.convertToCoinsAmount()
        }else {
            Logger.payServices.error("🔴 ERROR: Amount could not be decoded as Double, Int64, or valid String")
            throw DecodingError.dataCorruptedError(
                forKey: .amount,
                in: container,
                debugDescription: "🔴 ERROR: Amount could not be decoded as Double, Int64, or valid String"
            )
        }
        
        self.currency = try container.decode(String.self, forKey: .currency)
    }
}

//MARK: - Orders
public struct BatchPaymentOrderResultDetails: Decodable {
    let externalId: String
    let operationId: String
    let transactionId: String
    let status: String
    let statusCode: String?
    let statusDescription: String?
    let statusDescriptionEn: String?
    let statusDescriptionUk: String?

    enum CodingKeys: String, CodingKey {
        case externalId = "external_id"
        case operationId = "operation_id"
        case transactionId = "transaction_id"
        case status
        case statusCode = "status_code"
        case statusDescription = "status_description"
        case statusDescriptionEn = "status_description_en"
        case statusDescriptionUk = "status_description_uk"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.externalId = try container.decode(String.self, forKey: .externalId)
        self.operationId = try container.decode(String.self, forKey: .operationId)
        self.transactionId = try container.decode(String.self, forKey: .transactionId)
        self.status = try container.decode(String.self, forKey: .status)
        self.statusCode = try container.decodeIfPresent(String.self, forKey: .statusCode)
        self.statusDescription = try container.decodeIfPresent(String.self, forKey: .statusDescription)
        self.statusDescriptionEn = try container.decodeIfPresent(String.self, forKey: .statusDescriptionEn)
        self.statusDescriptionUk = try container.decodeIfPresent(String.self, forKey: .statusDescriptionUk)
    }
}

extension BatchPaymentOrderResultDetails: LocalizedStatusDescription {}

extension BatchPaymentOrderResultDetails {
    func convertToStatus() -> PaymentStatus {
        guard let status = PaymentStatus(rawValue: self.status) else {
            Logger.payServices.error("🔴 ERROR: Unknown payment status: \(self.status)")
            return .failure
        }
        return status
    }
}

extension Array where Element == BatchPaymentOrderResultDetails {
    
    func mapToBatchOrderPaymentResult() -> [BatchOrderPaymentResult] {
        return self.compactMap {
            return BatchOrderPaymentResult(
                externalId: $0.externalId,
                operationId: $0.operationId,
                status: $0.convertToStatus()
            )
        }
    }
}
