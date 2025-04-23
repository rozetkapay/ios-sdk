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
    public var orderId: String?
    
    private enum CodingKeys: String, CodingKey {
        case code = "code"
        case message = "message"
        case param = "param"
        case paymentId = "payment_id"
        case type = "type"
        case errorId = "error_id"
        case orderId = "order_id"
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
        self.orderId = try? container.decode(String.self, forKey: .orderId)
        self.errorDescription = try? container.decode(String.self, forKey: .errorDescription)
    }
    
    public init(
        code: String? = nil,
        message: String? = nil,
        param: String? = nil,
        orderId: String? = nil,
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
        self.orderId = orderId
        self.errorDescription = errorDescription
    }
    
    /// init unexpected error
    public init (
        orderId: String,
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
        self.orderId = orderId
    }

    
    public var localizedDescription: String {
        if let message = message.isNilOrEmptyValue {
            return message
        } else {
            var message = "Unknown error (code: \(code.rawValue), type: \(type.rawValue))"
            if let orderId = orderId {
                message += ", orderId: \(orderId)"
            }
            if let paymentId = paymentId {
                message += ", paymentId: \(paymentId)"
            }
            
            if let errorDescription = errorDescription {
                message += ", errorDescription: \(errorDescription)"
            }
            return message
        }
    }
    
    mutating func setOrderId(_ value: String) {
        self.orderId = value
    }
    
    mutating func setPaymentId(_ value: String) {
        self.paymentId = value
    }
}


extension PaymentError {
    
    static func convertFrom( _ apiError: APIError<Self>, orderId: String? = nil, paymentId: String? = nil) -> Self {
        
        switch apiError {
        case let .validation(model):
            var newModel = model
            
            if let orderId {
                newModel.setOrderId(orderId)
            }
            
            if let paymentId {
                newModel.setPaymentId(paymentId)
            }
            
            return newModel
        case let .decodingFailure(error):
            return PaymentError(
                code: ErrorResponseCode.unknownAction.rawValue,
                orderId: orderId,
                paymentId: paymentId,
                type: ErrorResponseType.unknownAction.rawValue,
                errorDescription: error.localizedDescription
            )
        case let .external(code, message):
            return PaymentError(
              code: ErrorResponseCode.unknown(code: code.description).rawValue,
              message: message,
              orderId: orderId,
              paymentId: paymentId,
              type: ErrorResponseType.paymentError.rawValue
          )
        case .networkUnreachable:
            return PaymentError(
                code: ErrorResponseCode.networkUnreachable.rawValue,
                orderId: orderId,
                paymentId: paymentId,
                type: ErrorResponseType.networkError.rawValue,
            )
        case .unknown:
            return PaymentError(
              orderId: orderId,
              paymentId: paymentId,
          )
        }
    }
}
