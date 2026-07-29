//
//  BatchApplePayFormParameters.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 03.07.2026.
//
import Foundation

/// Represents the parameters required to initiate a batch Apple Pay payment
/// via the embeddable `ApplePayFormView`.
/// Conforms to `ParametersProtocol`.
///
/// Batch payment is a payment with multiple orders in one transaction.
/// Each order is processed separately, but all are paid together.
/// Unlike `BatchPaymentParameters`, this configuration is Apple Pay only:
/// no card form is rendered, so `applePayConfig` is required.
public struct BatchApplePayFormParameters: ParametersProtocol {

    /// Client authentication parameters.
    public let client: ClientAuthParametersProtocol

    /// Theme configuration for the payment UI (3DS screen, button style).
    public let themeConfigurator: RozetkaPayThemeConfigurator

    public var viewParameters: ViewParametersProtocol {
        PaymentViewParameters()
    }

    /// Apple Pay configuration. Required — the form renders only the Apple Pay button.
    let applePayConfig: ApplePayConfig

    /// Payment amount details, including currency, tax, and total.
    let amountParameters: AmountParameters

    /// Unique external ID of the batch payment in your system.
    let externalId: String

    /// Optional URL that will be called after the payment is finished.
    let callbackUrl: String?

    /// URL used to detect 3DS confirmation completion.
    let resultUrl: String?

    /// List of orders to be paid in the batch.
    let orders: [BatchOrder]

    /// Creates a new instance of `BatchApplePayFormParameters`.
    public init(
        client: ClientAuthParameters,
        themeConfigurator: RozetkaPayThemeConfigurator = RozetkaPayThemeConfigurator(),
        applePayConfig: ApplePayConfig,
        amountParameters: AmountParameters,
        externalId: String,
        callbackUrl: String? = nil,
        orders: [BatchOrder]
    ) {
        self.client = client
        self.themeConfigurator = themeConfigurator
        self.applePayConfig = applePayConfig
        self.amountParameters = amountParameters
        self.externalId = externalId
        self.callbackUrl = callbackUrl
        self.resultUrl = EnvironmentProvider.environment.paymentsConfirmation3DsCallbackUrl
        self.orders = orders
    }

    var applePaymentService: ApplePaymentService? {
        return ApplePaymentService(
            externalId: self.externalId,
            config: self.applePayConfig,
            amount: self.amountParameters
        )
    }
}
