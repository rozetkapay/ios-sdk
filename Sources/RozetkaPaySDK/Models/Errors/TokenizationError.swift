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
        case errorDescription = "error"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if container.contains(.failed) {
            let message = try container.decode(String?.self, forKey: .message)
            let errorDescription = try container.decode(String?.self, forKey: .errorDescription)
            self = .failed(message: message, errorDescription: errorDescription)
        } else {
            self = .cancelled
        }
    }
    
    public var localizedDescription: String {
        switch self {
        case .cancelled:
            return "Tokenization was cancelled"
        case let .failed(message, errorDescription):
            if let desc = errorDescription.isNilOrEmptyValue {
                return desc
            } else if let message = message.isNilOrEmptyValue {
                return message
            } else {
                return "Unknown tokenization error"
            }
        }
    }
}

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
        case .networkUnreachable:
            return .cancelled
        case .unknown:
            return .failed(
                message: "Unknown error",
                errorDescription: nil
            )
        }
    }
}
