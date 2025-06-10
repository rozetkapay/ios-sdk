//
//  RozetkaPayConfig.swift
//
//
//  Created by Ruslan Kasian Dev on 03.09.2024.
//

import Foundation

/// Global configuration for RozetkaPay SDK.
///
/// This struct defines shared constants used across the SDK, including
/// environment URLs, default currency and country codes, legal links,
/// Apple Pay settings, and default networking timeouts.
struct RozetkaPayConfig {
    
    /// Default currency code used for payments.
    static let defaultCurrencyCode = "UAH"
    
    /// Default country code used for payments.
    static let defaultCountryCode = "UA"
    
    /// Development environment configuration:
    /// includes base URLs for tokenization, payments, and 3DS confirmation.
    static let devEnvironment = RozetkaPayEnvironment(
        tokenizationApiProviderUrl: "https://widget-epdev.rozetkapay.com",
        paymentsApiProviderUrl: "https://api-epdev.rozetkapay.com",
        paymentsConfirmation3DsCallbackUrl: "https://checkout-epdev.rozetkapay.com"
    )
    
    /// Production environment configuration:
    /// includes base URLs for tokenization, payments, and 3DS confirmation.
    static let prodEnvironment = RozetkaPayEnvironment(
        tokenizationApiProviderUrl: "https://widget.rozetkapay.com",
        paymentsApiProviderUrl: "https://api.rozetkapay.com",
        paymentsConfirmation3DsCallbackUrl: "https://checkout.rozetkapay.com"
    )
    
    /// URL to the legal public contract for money transfers.
    static let LEGAL_PUBLIC_CONTRACT_LINK = "https://rozetkapay.com/legal-info/perekaz-koshtiv/FO"
    
    /// URL to the legal company details for RozetkaPay.
    static let LEGAL_COMPANY_DETAILS_LINK = "https://rozetkapay.com/legal-info/perekaz-koshtiv/"
    
    /// Apple Pay gateway identifier used in the merchant configuration.
    static let APPLE_PAY_GATEWAY = "evopay"
    
    /// Apple Pay country code.
    static let APPLE_PAY_COUNTRY_CODE = "UA"
    
    /// Default network timeout settings used for API calls.
    static let network_TimeoutInterval: TimeoutInterval = .standart
    
    /// Default retry timeout in seconds for failed operations.
    static let DEFAULT_RETRY_TIMEOUT: TimeInterval = 30
    
    /// Delay in seconds between retry attempts.
    static let DEFAULT_RETRY_DELAY: TimeInterval = 1
}
