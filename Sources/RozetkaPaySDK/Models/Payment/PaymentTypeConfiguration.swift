//
//  PaymentTypeConfiguration.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 28.05.2025.
//
import Foundation

/// Enum describing available payment types:
/// - `regular`: Standard card or Apple Pay flow
/// - `singleToken`: Pre-tokenized card flow, no user input allowed
public enum PaymentTypeConfiguration {
    case regular(RegularPayment)
    case singleToken(SingleTokenPayment)
    
   
    public var viewParameters: ViewParametersProtocol {
        switch self {
        case .regular(let config):
            return config.viewParameters
        case .singleToken(_):
            return PaymentViewParameters()
        }
    }
    
    var isNeedToReturnTokenizationCard: Bool {
        switch self {
        case .regular(let config):
            return config.isAllowTokenization
        case .singleToken(_):
            return false
        }
    }
    
    var applePayConfig: ApplePayConfig? {
        switch self {
        case .regular(let config):
            return config.applePayConfig
        case .singleToken(_):
            return nil
        }
    }
    
    var isAllowApplePay: Bool {
        switch self {
        case .regular(let config):
            return config.applePayConfig?.checkApplePayAvailability() ?? false
        case .singleToken(_):
            return false
        }
    }
}
