//
//  MerchantCapabilityParser.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 19.01.2026.
//

import OSLog
import PassKit

// MARK: - MerchantCapabilityParser

/// A utility parser for converting string-based merchant capabilities to `PKMerchantCapability`.
///
/// This parser enables configuration of Apple Pay merchant capabilities using simple
/// string arrays instead of native iOS types.
///
/// ## Supported Capability Strings
///
/// | String Value | PKMerchantCapability | iOS Version |
/// |--------------|---------------------|-------------|
/// | `"3ds"`, `"threeDSecure"`, `"three_d_secure"` | `.threeDSecure` / `.capability3DS` | 8.0+ |
/// | `"emv"` | `.emv` / `.capabilityEMV` | 8.0+ |
/// | `"credit"` | `.credit` / `.capabilityCredit` | 9.0+ |
/// | `"debit"` | `.debit` / `.capabilityDebit` | 9.0+ |
/// | `"instantFundsOut"`, `"instant_funds_out"` | `.instantFundsOut` | 17.0+ |
///
/// ## Usage Example
///
/// ```swift
/// let capabilities = ["3ds", "credit", "debit"]
/// if let parsed = MerchantCapabilityParser.parse(capabilities) {
///     // Use parsed PKMerchantCapability
/// }
/// ```
///
/// - Note: String matching is case-insensitive.
/// - Note: Unknown capability strings are logged as warnings and skipped.
enum MerchantCapabilityParser {
    
    /// Parses an array of capability strings into a `PKMerchantCapability` option set.
    ///
    /// This method handles iOS version compatibility automatically, using the appropriate
    /// capability constants for the current iOS version (iOS 17+ uses new naming conventions).
    ///
    /// - Parameter capabilities: An array of capability strings (e.g., `["3ds", "credit", "debit"]`).
    ///   Accepts `nil` or empty arrays.
    /// - Returns: A `PKMerchantCapability` option set containing all valid parsed capabilities,
    ///   or `nil` if the input is `nil`, empty, or contains no valid capabilities.
    static func parse(_ capabilities: [String]?) -> PKMerchantCapability? {
        guard let capabilities = capabilities, !capabilities.isEmpty else {
            return nil
        }
        
        var result: PKMerchantCapability = []
        
        for capability in capabilities {
            switch capability.lowercased() {
            case "3ds", "threedsecure", "three_d_secure":
                if #available(iOS 17.0, *) {
                    result.insert(.threeDSecure)
                } else {
                    result.insert(.capability3DS)
                }
                
            case "emv":
                if #available(iOS 17.0, *) {
                    result.insert(.emv)
                } else {
                    result.insert(.capabilityEMV)
                }
                
            case "credit":
                if #available(iOS 17.0, *) {
                    result.insert(.credit)
                } else {
                    result.insert(.capabilityCredit)
                }
                
            case "debit":
                if #available(iOS 17.0, *) {
                    result.insert(.debit)
                } else {
                    result.insert(.capabilityDebit)
                }
                
            case "instantfundsout", "instant_funds_out":
                if #available(iOS 17.0, *) {
                    result.insert(.instantFundsOut)
                }
                
            default:
                Logger.payByApplePay.warning("⚠️ Unknown merchant capability: \(capability)")
            }
        }
        
        return result.isEmpty ? nil : result
    }
}
