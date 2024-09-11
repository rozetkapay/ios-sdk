//
//  RozetkaPayConfig.swift
//
//
//  Created by Ruslan Kasian Dev on 03.09.2024.
//

import Foundation

struct RozetkaPayConfig {
    
    /// Development environment configuration.
    static let devEnvironment = RozetkaPayEnvironment(
        tokenizationApiProviderUrl: "https://widget-epdev.rozetkapay.com",
        paymentsApiProviderUrl: "https://api-epdev.rozetkapay.com",
        paymentsConfirmation3DsCallbackUrl: "https://checkout-epdev.rozetkapay.com"
    )
    
    /// Production environment configuration.
    static let prodEnvironment = RozetkaPayEnvironment(
        tokenizationApiProviderUrl: "https://widget.rozetkapay.com",
        paymentsApiProviderUrl: "https://api.rozetkapay.com",
        paymentsConfirmation3DsCallbackUrl: "https://checkout.rozetkapay.com"
    )
    
    /// Legal public contract link.
    static let LEGAL_PUBLIC_CONTRACT_LINK = "https://drive.google.com/file/d/1CRg5UjDKvWLST5VCFkHB1Btv_FmomK8h/view"
    
    /// Legal company details link.
    static let LEGAL_COMPANY_DETAILS_LINK = "https://rozetkapay.com/legal-info/perekaz-koshtiv/"
    
    /// Google Pay gateway for RozetkaPay.
    static let APPLE_PAY_GATEWAY = "evopay"
    
    /// Google Pay country code for RozetkaPay.
    static let APPLE_PAY_COUNTRY_CODE = "UA"
    
    static let network_TimeoutInterval: TimeoutInterval = .standart
}
