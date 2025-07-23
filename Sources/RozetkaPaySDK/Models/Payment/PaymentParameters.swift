//
//  File.swift
//
//
//  Created by Ruslan Kasian Dev on 03.09.2024.
//

import Foundation

/// Represents the parameters required to initiate a payment.
/// Conforms to `ParametersProtocol`.
///
/// Use this model to configure client authentication, payment amount,
/// order details, and the type of payment (regular or tokenized).
public struct PaymentParameters: ParametersProtocol {
    
    /// Client authentication parameters.
    public let client: ClientAuthParametersProtocol
    
    /// Theme configuration for the payment UI.
    public let themeConfigurator: RozetkaPayThemeConfigurator
    
    public var viewParameters: ViewParametersProtocol {
        paymentType.viewParameters
    }
   
    /// Configuration for the payment type (regular or single token).
    let paymentType: PaymentTypeConfiguration
    
    /// Payment amount details, including currency, tax, and total.
    let amountParameters: AmountParameters
    
    /// Unique external ID in your system.
    let externalId: String
    
    /// Optional URL that will be called after the payment is finished.
    let callbackUrl: String?
    
    /// Optional URL that will be called after the payment is finished.
    let resultUrl: String?
    
    /// Creates a new instance of `PaymentParameters`.
    public init(
        client: ClientAuthParameters,
        themeConfigurator: RozetkaPayThemeConfigurator = RozetkaPayThemeConfigurator(),
        paymentType: PaymentTypeConfiguration = .regular(
            RegularPayment(viewParameters: PaymentViewParameters())
        ),
        amountParameters: AmountParameters,
        externalId: String,
        callbackUrl: String? = nil
    ) {
        self.client = client
        self.themeConfigurator = themeConfigurator
        self.amountParameters = amountParameters
        self.paymentType = paymentType
        self.externalId = externalId
        self.callbackUrl = callbackUrl
        self.resultUrl = EnvironmentProvider.environment.paymentsConfirmation3DsCallbackUrl
    }
    
    var applePaymentService: ApplePaymentService? {
        guard let config = self.paymentType.applePayConfig else {
            return nil
        }
        
        return ApplePaymentService(
            externalId: self.externalId,
            config: config,
            amount:  self.amountParameters
        )
    }
}

