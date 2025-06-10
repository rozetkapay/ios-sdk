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
    ///   - merchantCapabilities: Optional capabilities. Defaults to `.capability3DS`.
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
        self.merchantCapabilities = merchantCapabilities ?? .capability3DS
        self.countryCode = countryCode ?? RozetkaPayConfig.defaultCountryCode
        self.currencyCode = currencyCode ?? RozetkaPayConfig.defaultCurrencyCode
    }
    
    /// Test configuration for sandbox Apple Pay.
    public class Test: ApplePayConfig {
        /// Initializes a test config with default merchant name.
        public init(
            merchantIdentifier: String,
            merchantName: String = "RozetkaPay Test Merchant",
            currencyCode: String? = nil,
            countryCode: String? = nil
        ) {
            super.init(
                merchantIdentifier: merchantIdentifier,
                merchantName: merchantName,
                currencyCode: currencyCode,
                countryCode: countryCode
            )
        }
    }
    
    /// Production configuration for live Apple Pay.
    public class Production: ApplePayConfig {
        /// Initializes a production config with required merchant info.
        public init(
            merchantIdentifier: String,
            merchantName: String,
            supportedNetworks: [PKPaymentNetwork] = [.visa, .masterCard],
            merchantCapabilities: PKMerchantCapability = .capability3DS,
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
    /// - Returns: `true` if Apple Pay is available and supports the configured networks; otherwise, `false`.
    func checkApplePayAvailability() -> Bool {
        if PKPaymentAuthorizationController.canMakePayments() {
            Logger.payByApplePay.info("🍏 Apple Pay is available on this device. 🍏")
            
            if PKPaymentAuthorizationController.canMakePayments(usingNetworks: supportedNetworks) {
                Logger.payByApplePay.info("Apple Pay supports payment networks: [\(supportedNetworks.debugDescription)].")
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
