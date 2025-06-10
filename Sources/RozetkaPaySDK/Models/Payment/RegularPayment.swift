//
//  RegularPayment.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 28.05.2025.
//
import Foundation

/// Configuration for regular card-based payments or Apple Pay.
public struct RegularPayment {
    /// UI and field configuration for the payment screen.
    let viewParameters: ViewParametersProtocol

    /// Whether card should be tokenized during the payment.
    /// If true, a token will be returned in the response.
    let isAllowTokenization: Bool

    /// Apple Pay configuration. If `nil`, Apple Pay is disabled.
    let applePayConfig: ApplePayConfig?

    public init(
        viewParameters: PaymentViewParameters = PaymentViewParameters(),
        isAllowTokenization: Bool = true,
        applePayConfig: ApplePayConfig? = nil
    ) {
        self.viewParameters = viewParameters
        self.isAllowTokenization = isAllowTokenization
        self.applePayConfig = applePayConfig
    }
}
