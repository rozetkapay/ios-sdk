//
//  ApplePayConfig.swift
//
//
//  Created by Ruslan Kasian Dev on 03.09.2024.
//

import Foundation
import PassKit
import OSLog

/// Configuration object for Apple Pay payments.
///
/// Provides all necessary settings for initializing Apple Pay,
/// including merchant information, supported card networks,
/// capabilities, currency, and country codes.
public class ApplePayConfig {
    
    /// The merchant identifier registered with Apple.
    let merchantIdentifier: String
    
    /// Display name for the merchant.
    let merchantName: String
    
    /// List of supported card networks (e.g. Visa, MasterCard).
    let supportedNetworks: [PKPaymentNetwork]
    
    /// Merchant capabilities (e.g. 3DS).
    let merchantCapabilities: PKMerchantCapability
    
    /// Payment currency code (e.g. "UAH").
    let currencyCode: String
    
    /// Country code for the transaction (e.g. "UA").
    let countryCode: String
    
    /// Initializes a general Apple Pay configuration.
    ///
    /// - Parameters:
    ///   - merchantIdentifier: Your Apple Pay merchant ID.
    ///   - merchantName: The merchant name displayed in the payment sheet.
    ///   - supportedNetworks: Optional list of card networks. Defaults to Visa and MasterCard.
    ///   - merchantCapabilities: Optional capabilities. Defaults to `[.capability3DS, .capabilityDebit, .capabilityCredit]`.
    ///   - currencyCode: Optional currency code. Defaults to `RozetkaPayConfig.defaultCurrencyCode`.
    ///   - countryCode: Optional country code. Defaults to `RozetkaPayConfig.defaultCountryCode`.
    init(
        merchantIdentifier: String,
        merchantName: String,
        supportedNetworks: [PKPaymentNetwork]? = nil,
        merchantCapabilities: PKMerchantCapability? = nil,
        currencyCode: String? = nil,
        countryCode: String? = nil
    ) {
        self.merchantIdentifier = merchantIdentifier
        self.merchantName = merchantName
        self.supportedNetworks = supportedNetworks ?? [.visa, .masterCard]
        
        if #available(iOS 17.0, *) {
            self.merchantCapabilities = merchantCapabilities ?? [.threeDSecure, .debit, .credit]
        } else {
            self.merchantCapabilities = merchantCapabilities ?? [.capability3DS, .capabilityDebit, .capabilityCredit]
        }
        
        self.countryCode = countryCode ?? RozetkaPayConfig.defaultCountryCode
        self.currencyCode = currencyCode ?? RozetkaPayConfig.defaultCurrencyCode
    }
    
    // MARK: - String-Based Initializer
    
    /// Initializes Apple Pay configuration with string-based parameters.
    ///
    /// This initializer provides a convenient way to configure Apple Pay using string arrays,
    /// which is useful for configurations loaded from JSON, remote configs, or bridge interfaces.
    ///
    /// - Parameters:
    ///   - merchantIdentifier: Your Apple Pay merchant ID registered in Apple Developer Portal.
    ///   - merchantName: The merchant name displayed in the payment sheet.
    ///   - supportedNetworks: Array of network strings. Supported values: `"visa"`, `"mastercard"`, `"amex"`, `"discover"`, `"maestro"`.
    ///     Defaults to `["visa", "mastercard"]` if `nil` or empty.
    ///   - merchantCapabilities: Array of capability strings. Supported values: `"3ds"`, `"credit"`, `"debit"`, `"emv"`, `"instantFundsOut"`.
    ///     Defaults to `["3ds", "credit", "debit"]` if `nil` or empty.
    ///   - currencyCode: ISO 4217 currency code (e.g., `"UAH"`, `"USD"`). Defaults to `RozetkaPayConfig.defaultCurrencyCode`.
    ///   - countryCode: ISO 3166-1 alpha-2 country code (e.g., `"UA"`, `"US"`). Defaults to `RozetkaPayConfig.defaultCountryCode`.
    ///
    /// ## Supported Network Strings
    ///
    /// | String | Network | iOS |
    /// |--------|---------|-----|
    /// | `"visa"` | Visa | 8.0+ |
    /// | `"mastercard"` | MasterCard | 8.0+ |
    /// | `"amex"` | American Express | 8.0+ |
    /// | `"discover"` | Discover | 9.0+ |
    /// | `"maestro"` | Maestro | 12.0+ |
    ///
    /// ## Supported Capability Strings
    ///
    /// | String | Capability | iOS |
    /// |--------|------------|-----|
    /// | `"3ds"` | 3D Secure | 8.0+ |
    /// | `"credit"` | Credit cards | 9.0+ |
    /// | `"debit"` | Debit cards | 9.0+ |
    /// | `"emv"` | EMV | 8.0+ |
    /// | `"instantFundsOut"` | Instant Funds Out | 17.0+ |
    ///
    /// - Note: String matching is case-insensitive.
    /// - Note: Unknown values are logged as warnings and skipped.
    public convenience init(
        merchantIdentifier: String,
        merchantName: String,
        supportedNetworks: [String]?,
        merchantCapabilities: [String]?,
        currencyCode: String?,
        countryCode: String?
    ) {
        self.init(
            merchantIdentifier: merchantIdentifier,
            merchantName: merchantName,
            supportedNetworks: PaymentNetworkParser.parse(supportedNetworks),
            merchantCapabilities: MerchantCapabilityParser.parse(merchantCapabilities),
            currencyCode: currencyCode,
            countryCode: countryCode
        )
    }
    
    // MARK: - Subclasses
    
    /// Test configuration for sandbox Apple Pay environment.
    public class Test: ApplePayConfig {
        /// Initializes a test config with default merchant name.
        public override init(
            merchantIdentifier: String,
            merchantName: String = "RozetkaPay Test Merchant",
            supportedNetworks: [PKPaymentNetwork]? = nil,
            merchantCapabilities: PKMerchantCapability? = nil,
            currencyCode: String? = nil,
            countryCode: String? = nil
        ) {
            super.init(
                merchantIdentifier: merchantIdentifier,
                merchantName: merchantName,
                supportedNetworks: supportedNetworks,
                merchantCapabilities: merchantCapabilities,
                currencyCode: currencyCode,
                countryCode: countryCode
            )
        }
    }
    
    /// Production configuration for live Apple Pay.
    public class Production: ApplePayConfig {
        /// Initializes a production config with required merchant info.
        public override init(
            merchantIdentifier: String,
            merchantName: String,
            supportedNetworks: [PKPaymentNetwork]? = nil,
            merchantCapabilities: PKMerchantCapability? = nil,
            currencyCode: String? = nil,
            countryCode: String? = nil
        ) {
            super.init(
                merchantIdentifier: merchantIdentifier,
                merchantName: merchantName,
                supportedNetworks: supportedNetworks,
                merchantCapabilities: merchantCapabilities,
                currencyCode: currencyCode,
                countryCode: countryCode
            )
        }
    }
    
    /// Checks whether Apple Pay is available and configured correctly on the device.
    ///
    /// Logs detailed messages using `Logger.payByApplePay`.
    /// - Returns: `true` if Apple Pay is available and supports the configured networks and capabilities; otherwise, `false`.
    func checkApplePayAvailability() -> Bool {
        if PKPaymentAuthorizationController.canMakePayments() {
            Logger.payByApplePay.info("🍏 Apple Pay is available on this device. 🍏")
            
            if PKPaymentAuthorizationController.canMakePayments(
                usingNetworks: supportedNetworks,
                capabilities: merchantCapabilities
            ) {
                Logger.payByApplePay.info("Apple Pay supports payment networks: [\(supportedNetworks.debugDescription)], capabilities: [\(merchantCapabilities.debugDescription)]")
                return true
            } else {
                Logger.payByApplePay.warning("⚠️ Apple Pay is available but doesn't support these networks: [\(supportedNetworks.debugDescription)].")
                return false
            }
        } else {
            Logger.payByApplePay.warning("⚠️ Apple Pay is not available on this device.")
            return false
        }
    }
}
