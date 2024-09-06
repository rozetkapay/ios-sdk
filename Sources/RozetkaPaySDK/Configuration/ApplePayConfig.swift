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
    let merchantIdentifier: String //"merchant.com.YOURDOMAIN.YOURAPPNAME"
    let merchantName: String
    let supportedNetworks: [PKPaymentNetwork]
    let merchantCapabilities: PKMerchantCapability
    
    public init(
        merchantIdentifier: String,
        merchantName: String,
        supportedNetworks: [PKPaymentNetwork]? = nil,
        merchantCapabilities: PKMerchantCapability? = nil
    ) {
        self.merchantIdentifier = merchantIdentifier
        self.merchantName = merchantName
        self.supportedNetworks = supportedNetworks ?? [.visa, .masterCard]
        self.merchantCapabilities = merchantCapabilities ?? .capability3DS
    }
    
    public class Test: ApplePayConfig {
        public init(
            merchantIdentifier: String,
            merchantName: String = "RozetkaPay Test Merchant"
        ) {
            super.init(
                merchantIdentifier: merchantIdentifier,
                merchantName: merchantName
            )
        }
    }
    
    public class Production: ApplePayConfig {
        public init(
            merchantIdentifier: String,
            merchantName: String,
            supportedNetworks: [PKPaymentNetwork] = [.visa, .masterCard],
            merchantCapabilities: PKMerchantCapability = .capability3DS
        ) {
            super.init(
                merchantIdentifier: merchantIdentifier,
                merchantName: merchantName,
                supportedNetworks: supportedNetworks,
                merchantCapabilities: merchantCapabilities
            )
        }
    }
    
    func checkApplePayAvailability() -> Bool {
        if PKPaymentAuthorizationController.canMakePayments() {
            Logger.applePay.info(
                "🍏 Apple Pay is available on this device. 🍏"
            )
        
            if PKPaymentAuthorizationController.canMakePayments(usingNetworks: supportedNetworks) {
                Logger.applePay.info("Apple Pay is available and supports payment networks: [\(supportedNetworks.debugDescription)].")
                return true
            } else {
                Logger.applePay.warning("⚠️ WARNING: Apple Pay is available but does not support payment networks: [\(supportedNetworks.debugDescription)].")
                return false
            }
        } else {
            Logger.applePay.warning("⚠️ WARNING: Apple Pay is not available on this device.")
            return false
        }
    }
}

