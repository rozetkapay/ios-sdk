//
//  BatchPaymentParameters.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 29.05.2025.
//


import Foundation

/// Represents the parameters required to initiate a payment.
/// Conforms to `BatchPaymentParameters`.
///
/// Parameters for batch payment.
/// Batch payment is a payment with multiple orders in one transaction.
/// Each order is processed separately, but all are paid together.
public struct BatchPaymentParameters: ParametersProtocol {
    
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
    
    /// Unique external ID of the batch payment in your system.
    let externalId: String
    
    /// Optional URL that will be called after the payment is finished.
    let callbackUrl: String?
    
    /// Optional URL that will be called after the payment is finished.
    let resultUrl: String?
    
    /// List of orders to be paid in the batch.
    let orders: [BatchOrder]
    
    /// Creates a new instance of `PaymentParameters`.
    public init(
        client: ClientAuthParameters,
        themeConfigurator: RozetkaPayThemeConfigurator = RozetkaPayThemeConfigurator(),
        paymentType: PaymentTypeConfiguration = .regular(
            RegularPayment(viewParameters: PaymentViewParameters())
        ),
        amountParameters: AmountParameters,
        externalId: String,
        callbackUrl: String? = nil,
        orders: [BatchOrder]
    ) {
        self.client = client
        self.themeConfigurator = themeConfigurator
        self.amountParameters = amountParameters
        self.paymentType = paymentType
        self.externalId = externalId
        self.callbackUrl = callbackUrl
        self.resultUrl = EnvironmentProvider.environment.paymentsConfirmation3DsCallbackUrl
        self.orders = orders
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
