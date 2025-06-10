//
//  ThreeDSRequest.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 17.04.2025.
//
import Foundation

struct ThreeDSRequest {
    //MARK: - Properties
    let externalId: String
    let acsUrl: String
    let termUrl: String?
    let paymentId: String?
    let tokenizedCard: TokenizedCard?
    let ordersPayments: [BatchOrderPaymentResult]?
    
    //MARK: - Inits
   
    init(
        externalId: String,
        acsUrl: String,
        termUrl: String?,
        paymentId: String? = nil,
        tokenizedCard: TokenizedCard? = nil,
        ordersPayments: [BatchOrderPaymentResult]? = nil
    ) {
        self.externalId = externalId
        self.acsUrl = acsUrl
        self.termUrl = termUrl
        self.paymentId = paymentId
        self.tokenizedCard = tokenizedCard
        self.ordersPayments = ordersPayments
    }
}
