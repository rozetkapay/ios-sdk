//
//  CreatePaymentResponse.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 14.04.2025.
//
import Foundation
import OSLog

public struct CreatePaymentResponse: Decodable {
    let action: PaymentResultAction?
    let details: PaymentResultDetails
    let receiptUrl: String?
    
    private enum CodingKeys: String, CodingKey {
        case action
        case details
        case receiptUrl = "receipt_url"
    }
 
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.action = try container.decodeIfPresent(PaymentResultAction.self, forKey: .action)
        self.details = try container.decode(PaymentResultDetails.self, forKey: .details)
        self.receiptUrl = try container.decodeIfPresent(String.self, forKey: .receiptUrl)
    }
}

extension CreatePaymentResponse {
    func convertToCreatePaymentData() -> CreatePaymentData {
        return CreatePaymentData(
            action: self.action?.convertToAction(),
            paymentId: self.details.paymentId,
            status: self.details.convertToStatus(),
            statusCode: self.details.statusCode,
            statusDescription: self.details.statusDescription
        )
    }
}

public struct PaymentResultDetails: Decodable {
    let paymentId: String
    let status: String
    let statusCode: String
    let statusDescription: String?
    
    private enum CodingKeys: String, CodingKey {
        case paymentId = "payment_id"
        case status
        case statusCode = "status_code"
        case statusDescription = "status_description"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.paymentId = try container.decode(String.self, forKey: .paymentId)
        self.status = try container.decode(String.self, forKey: .status)
        self.statusCode = try container.decode(String.self, forKey: .statusCode)
        self.statusDescription = try container.decodeIfPresent(String.self, forKey: .statusDescription)
    }
}

extension PaymentResultDetails {
    func convertToStatus() -> PaymentStatus {
        guard let status = PaymentStatus(rawValue: self.status) else {
            Logger.payServices.error("Unknown payment status: \(self.status)")
            return .failure
        }
        return status
    }
}

public struct PaymentResultAction: Decodable {
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

extension PaymentResultAction {
    func convertToAction() -> CreatePaymentData.Action {
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


