//
//  ApplePayConfig.swift
//
//
//  Created by Ruslan Kasian Dev on 03.09.2024.
//

import Foundation
import PassKit
import OSLog

public class ApplePayConfig {
    let merchantIdentifier: String
    let merchantName: String
    let supportedNetworks: [PKPaymentNetwork]
    let merchantCapabilities: PKMerchantCapability
    let currencyCode: String
    let countryCode: String
    
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
        self.countryCode = countryCode ?? "UA"
        self.currencyCode = currencyCode ?? "UAH"
    }
    
    public class Test: ApplePayConfig {
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
    
    public class Production: ApplePayConfig {
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
    
    func checkApplePayAvailability() -> Bool {
        if PKPaymentAuthorizationController.canMakePayments() {
            Logger.payByApplePay.info(
                "🍏 Apple Pay is available on this device. 🍏"
            )
        
            if PKPaymentAuthorizationController.canMakePayments(usingNetworks: supportedNetworks) {
                Logger.payByApplePay.info("Apple Pay is available and supports payment networks: [\(supportedNetworks.debugDescription)].")
                return true
            } else {
                Logger.payByApplePay.warning("⚠️ WARNING: Apple Pay is available but does not support payment networks: [\(supportedNetworks.debugDescription)].")
                return false
            }
        } else {
            Logger.payByApplePay.warning("⚠️ WARNING: Apple Pay is not available on this device.")
            return false
        }
    }
}

