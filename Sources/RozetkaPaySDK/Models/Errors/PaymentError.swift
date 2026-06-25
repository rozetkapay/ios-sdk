//
//  PaymentError.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 15.04.2025.
//
import Foundation

public struct PaymentError: Error, Decodable {
    public let code: ErrorResponseCode
    public let message: String?
    public let errorDescription: String?
    public let param: String?
    public var paymentId: String?
    public let type: ErrorResponseType
    public let errorId: String?
    public var externalId: String?
    
    private enum CodingKeys: String, CodingKey {
        case code = "code"
        case message = "message"
        case param = "param"
        case paymentId = "payment_id"
        case type = "type"
        case errorId = "error_id"
        case externalId = "external_id"
        case errorDescription = "error"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decodeIfPresent(ErrorResponseCode.self, forKey: .code) ?? .unknown(code: "unknown")
        self.type = try container.decodeIfPresent(ErrorResponseType.self, forKey: .type) ?? .unknown(type: "unknown")
        self.message = try? container.decode(String.self, forKey: .message)
        self.param = try? container.decode(String.self, forKey: .param)
        self.paymentId = try? container.decode(String.self, forKey: .paymentId)
        self.errorId = try? container.decode(String.self, forKey: .errorId)
        self.externalId = try? container.decode(String.self, forKey: .externalId)
        self.errorDescription = try? container.decode(String.self, forKey: .errorDescription)
    }
    
    public init(
        code: String? = nil,
        message: String? = nil,
        param: String? = nil,
        externalId: String? = nil,
        paymentId: String? = nil,
        type: String? = nil,
        errorId: String? = nil,
        errorDescription: String? = nil
    ) {
        self.code = ErrorResponseCode.from(rawValue: code)
        self.message = message
        self.param = param
        self.paymentId = paymentId
        self.type = ErrorResponseType.from(rawValue: type)
        self.errorId = errorId
        self.externalId = externalId
        self.errorDescription = errorDescription
    }
    
    /// init unexpected error
    public init (
        externalId: String,
        message: String? = nil,
        errorDescription: String? = nil
    ) {
        self.code = ErrorResponseCode.from(rawValue: nil)
        self.message = message ?? "An unexpected error occurred"
        self.errorDescription = errorDescription
        self.param = nil
        self.paymentId = nil
        self.type = ErrorResponseType.from(rawValue: nil)
        self.errorId = nil
        self.externalId = externalId
    }
    
    
    public var localizedDescription: String {
        let primary = message.isNilOrEmptyValue
            ?? errorDescription.isNilOrEmptyValue
            ?? code.localizedDescription
            ?? fallbackDescription

        var parts = [primary]
        if let externalId = externalId {
            parts.append("externalId: \(externalId)")
        }
        if let paymentId = paymentId {
            parts.append("paymentId: \(paymentId)")
        }
        return parts.joined(separator: ", ")
    }

    /// Generic message used when neither server text nor a localized code is available.
    private var fallbackDescription: String {
        let key = "rozetka_pay_error_unknown_code"
        let template = Localization.localizedString(forKey: key)
        return template != key
            ? template.replacingOccurrences(of: "%1", with: code.rawValue)
            : "Payment error (code: \(code.rawValue))"
    }

    /// Diagnostic representation for logs
    public var debugDescription: String {
        var parts: [String] = [
            "code: \(code.rawValue)",
            "type: \(type.rawValue)",
        ]
        if let message = message { parts.append("message: \(message)") }
        if let errorDescription = errorDescription { parts.append("error: \(errorDescription)") }
        if let param = param { parts.append("param: \(param)") }
        if let externalId = externalId { parts.append("externalId: \(externalId)") }
        if let paymentId = paymentId { parts.append("paymentId: \(paymentId)") }
        if let errorId = errorId { parts.append("errorId: \(errorId)") }
        return "PaymentError(\(parts.joined(separator: ", ")))"
    }
    
    mutating func setExternalId(_ value: String) {
        self.externalId = value
    }
    
    mutating func setPaymentId(_ value: String) {
        self.paymentId = value
    }
}


extension PaymentError {
    
    static func convertFrom(
        _ apiError: APIError<Self>,
        externalId: String? = nil,
        paymentId: String? = nil
    ) -> Self {
        
        switch apiError {
        case let .validation(model):
            var newModel = model
            
            if let externalId {
                newModel.setExternalId(externalId)
            }
            
            if let paymentId {
                newModel.setPaymentId(paymentId)
            }
            
            return newModel
        case let .decodingFailure(error):
            return PaymentError(
                code: ErrorResponseCode.unknownAction.rawValue,
                externalId: externalId,
                paymentId: paymentId,
                type: ErrorResponseType.unknownAction.rawValue,
                errorDescription: error.localizedDescription
            )
        case let .external(code, message):
            return PaymentError(
                code: ErrorResponseCode.unknown(code: code.description).rawValue,
                message: message,
                externalId: externalId,
                paymentId: paymentId,
                type: ErrorResponseType.paymentError.rawValue
            )
        case .networkUnreachable:
            return PaymentError(
                code: ErrorResponseCode.networkUnreachable.rawValue,
                externalId: externalId,
                paymentId: paymentId,
                type: ErrorResponseType.networkError.rawValue
            )
        case .unknown:
            return PaymentError(
                externalId: externalId,
                paymentId: paymentId
            )
        }
    }
}
