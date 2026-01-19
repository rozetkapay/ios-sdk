//
//  PaymentNetworkParser.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 19.01.2026.
//

import OSLog
import PassKit

// MARK: - PaymentNetworkParser

/// A utility parser for converting string-based payment networks to `PKPaymentNetwork`.
///
/// This parser enables configuration of Apple Pay supported networks using simple
/// string arrays instead of native iOS types.
///
/// ## Supported Network Strings
///
/// | String Value | PKPaymentNetwork | iOS Version |
/// |--------------|------------------|-------------|
/// | `"visa"` | `.visa` | 8.0+ |
/// | `"mastercard"` | `.masterCard` | 8.0+ |
/// | `"amex"` | `.amex` | 8.0+ |
/// | `"discover"` | `.discover` | 9.0+ |
/// | `"maestro"` | `.maestro` | 12.0+ |
///
/// ## Usage Example
///
/// ```swift
/// let networks = ["visa", "mastercard"]
/// if let parsed = PaymentNetworkParser.parse(networks) {
///     // Use parsed [PKPaymentNetwork]
/// }
/// ```
///
/// - Note: String matching is case-insensitive.
/// - Note: Unknown network strings are logged as warnings and skipped.
/// - Note: Networks unavailable on the current iOS version are silently skipped.
enum PaymentNetworkParser {
    
    /// Parses an array of network strings into an array of `PKPaymentNetwork`.
    ///
    /// This method handles iOS version compatibility automatically, only including
    /// networks that are available on the current iOS version.
    ///
    /// - Parameter networks: An array of network strings (e.g., `["visa", "mastercard"]`).
    ///   Accepts `nil` or empty arrays.
    /// - Returns: An array of `PKPaymentNetwork` containing all valid parsed networks,
    ///   or `nil` if the input is `nil`, empty, or contains no valid networks.
    static func parse(_ networks: [String]?) -> [PKPaymentNetwork]? {
        guard let networks = networks, !networks.isEmpty else {
            return nil
        }
        
        var result: [PKPaymentNetwork] = []
        
        for network in networks {
            switch network.lowercased() {
            case "visa":
                result.append(.visa)
                
            case "mastercard":
                result.append(.masterCard)
                
            case "amex":
                result.append(.amex)
                
            case "discover":
                result.append(.discover)
                
            case "maestro":
                if #available(iOS 12.0, *) {
                    result.append(.maestro)
                }
                
            default:
                Logger.payByApplePay.warning("⚠️ Unknown payment network: \(network)")
            }
        }
        
        return result.isEmpty ? nil : result
    }
}
