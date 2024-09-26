//
//  File.swift
//  
//
//  Created by Ruslan Kasian Dev on 03.09.2024.
//

import Foundation

public struct PaymentParameters: ParametersProtocol {
    public let client: ClientAuthParametersProtocol
    public let viewParameters: ViewParametersProtocol
    public let themeConfigurator: RozetkaPayThemeConfigurator
    
    let amountParameters: AmountParameters
    let orderId: String
    let callbackUrl: String?
    let isAllowTokenization: Bool
    let applePayConfig: ApplePayConfig?
    
    public struct AmountParameters: Codable {
        let amount: Int64
        let currencyCode: String
        let tax: Int64?
        let total: Int64
        
        public init(
            amount: Int64,
            tax: Int64? = nil,
            total: Int64? = nil,
            currencyCode: String
        ) {
            self.amount = amount
            self.tax = tax
            if let total =  total.isNilOrEmptyValue {
                self.total = total
            }else {
                self.total = self.amount + (self.tax ?? 0)
            }
            self.currencyCode = currencyCode
        }
        
        public init(
            amount: Double,
            tax: Double? = nil,
            total: Double? = nil,
            currencyCode: String
        ) {
            self.amount = amount.convertToCoinsAmount()
            self.tax = tax?.convertToCoinsAmount()
            if let total =  total.isNilOrEmptyValue {
                self.total = total.convertToCoinsAmount()
            }else {
                self.total = self.amount + (self.tax ?? 0)
            }
            self.currencyCode = currencyCode
        }
    }
    
    public init(
        client: ClientAuthParameters,
        viewParameters: PaymentViewParameters = PaymentViewParameters(),
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
        self.viewParameters = viewParameters
        self.themeConfigurator = themeConfigurator
    }
}
