//
//  File.swift
//  
//
//  Created by Ruslan Kasian Dev on 03.09.2024.
//

import Foundation

public struct PaymentParameters {
    let client: ClientAuthParameters
    let viewFieldsParameters: PaymentViewParameters
    let themeConfigurator: RozetkaPayThemeConfigurator

    let amountParameters: AmountParameters
    let orderId: String
    let callbackUrl: String?
    let isAllowTokenization: Bool
    let applePayConfig: ApplePayConfig?
    
    public struct AmountParameters: Codable {
        let amount: Int64
        let currencyCode: String
        
        public init(amount: Int64, currencyCode: String) {
            self.amount = amount
            self.currencyCode = currencyCode
        }
        
        public init(amount: Double, currencyCode: String) {
            self.amount = amount.convertToCoinsAmount()
            self.currencyCode = currencyCode
        }
    }
    
    public init(
        client: ClientAuthParameters,
        viewFieldsParameters: PaymentViewParameters = PaymentViewParameters(),
        themeConfigurator: RozetkaPayThemeConfigurator = RozetkaPayThemeConfigurator(),
        amountParameters: AmountParameters,
        orderId: String,
        callbackUrl: String? = nil,
        isAllowTokenization: Bool = true,
        applePayConfig: ApplePayConfig? = nil
    ) {
        self.amountParameters = amountParameters
        self.orderId = orderId
        self.callbackUrl = callbackUrl
        self.isAllowTokenization = isAllowTokenization
        self.applePayConfig = applePayConfig
        self.client = client
        self.viewFieldsParameters = viewFieldsParameters
        self.themeConfigurator = themeConfigurator
    }
}
