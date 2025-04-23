//
//  ErrorType.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 16.04.2025.
//
import Foundation

public enum ErrorResponseType: Error, Decodable, Equatable {
    case invalidRequestError
    case paymentMethodError
    case paymentSettingsError
    case paymentError
    case applePayError
    case apiError
    case customerError
    case unknownAction
    case networkError
    case unknown(type: String)
    
    public var rawValue: String {
        switch self {
        case .invalidRequestError: return "invalid_request_error"
        case .paymentMethodError: return "payment_method_error"
        case .paymentSettingsError: return "payment_settings_error"
        case .paymentError: return "payment_error"
        case .applePayError: return "apple_pay_error"
        case .apiError: return "api_error"
        case .customerError: return "customer_error"
        case .unknownAction: return "unknown_action"
        case .networkError: return "network_error"
        case .unknown(let type): return type
        }
    }
    
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        self = ErrorResponseType.from(rawValue: raw)
    }
    
    public static func from(rawValue: String? ) -> ErrorResponseType {
        guard let rawValue else {
            return .unknown(type: "unknown")
        }
        
        switch rawValue {
        case "invalid_request_error": return .invalidRequestError
        case "payment_method_error": return .paymentMethodError
        case "payment_settings_error": return .paymentSettingsError
        case "payment_error": return .paymentError
        case "apple_pay_error": return .applePayError
        case "api_error": return .apiError
        case "customer_error": return .customerError
        case "unknown_action": return .unknownAction
        case "network_error": return .networkError
        default: return .unknown(type: rawValue)
        }
    }
}

