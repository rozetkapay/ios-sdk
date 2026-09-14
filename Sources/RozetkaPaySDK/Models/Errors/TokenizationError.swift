//
//  TokenizationError.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 16.04.2025.
//
import Foundation

public enum TokenizationError: Error, Decodable {
    case failed(message: String?, errorDescription: String?)
    case cancelled

    private enum CodingKeys: String, CodingKey {
        case failed
        case cancelled
        case message
        case errorDescription = "error_message"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
         if container.contains(.cancelled) {
            self = .cancelled
         }else {
             let message = try container.decodeIfPresent(String.self, forKey: .message)
             let errorDescription = try container.decodeIfPresent(String.self, forKey: .errorDescription)
             self = .failed(message: message, errorDescription: errorDescription)
         }
    }
    
    /// Message to display to the buyer.
    ///
    /// Carries no technical details — see `debugDescription` for those.
    public var localizedDescription: String {
        switch self {
        case .cancelled:
            return "Tokenization was cancelled"
        case let .failed(message, _):
            return message.isNilOrEmptyValue
                ?? Localization.rozetka_pay_common_error_message.description
        }
    }

    /// Diagnostic representation for logs.
    public var debugDescription: String {
        switch self {
        case .cancelled:
            return "TokenizationError(cancelled)"
        case let .failed(message, errorDescription):
            var parts: [String] = []
            if let message = message { parts.append("message: \(message)") }
            if let errorDescription = errorDescription { parts.append("error: \(errorDescription)") }
            return "TokenizationError(\(parts.joined(separator: ", ")))"
        }
    }
}

extension TokenizationError: CustomDebugStringConvertible {}

extension TokenizationError {
    
    static func convertFrom(_ apiError: APIError<Self>) -> Self {
        switch apiError {
        case let .validation(model):
            return model
            
        case let .decodingFailure(error):
            return .failed(
                message: nil,
                errorDescription: error.localizedDescription
            )
            
        case let .external(code, message):
            var text = "Unknown error (code: \(code))"
            if let message = message {
                text += ", message: \(message)"
            }
            return .failed(
                message: text,
                errorDescription: nil
            )
            
        case let .networkUnreachable(code, message):
            var text = "Network unreachable (code: \(code))"
            if let message = message {
                text += ", message: \(message)"
            }
            return .failed(
                message: text,
                errorDescription: nil
            )
            
        case let .unknown(code, message):
            var text = "Unknown error (code: \(code))"
            if let message = message {
                text += ", message: \(message)"
            }
            return .failed(
                message: text,
                errorDescription: nil
            )
        }
    }
    
    func convertToCreatePaymentResult(_ externalId: String?) -> CreatePaymentResult {
        switch self {
        case .cancelled:
            return .cancelled(
                    externalId: externalId,
                    paymentId: nil
                )
        case let .failed(message, errorDescription):
            let errorModel = PaymentError(
                code: ErrorResponseCode.failedToVerifyCard.rawValue,
                message: message,
                externalId: externalId,
                paymentId: nil,
                type: ErrorResponseType.paymentError.rawValue,
                errorDescription: errorDescription
            )

            return .failed(error: errorModel)
        }
    }

    func convertToCreateBatchPaymentResult(_ batchExternalId: String) -> CreateBatchPaymentResult {
        switch self {
        case .cancelled:
            return .cancelled(batchExternalId: batchExternalId)
        case let .failed(message, errorDescription):
            let errorModel = PaymentError(
                code: ErrorResponseCode.failedToVerifyCard.rawValue,
                message: message,
                externalId: batchExternalId,
                paymentId: nil,
                type: ErrorResponseType.paymentError.rawValue,
                errorDescription: errorDescription
            )

            return .failed(
                batchExternalId: batchExternalId,
                error: errorModel
            )
        }
    }
}
