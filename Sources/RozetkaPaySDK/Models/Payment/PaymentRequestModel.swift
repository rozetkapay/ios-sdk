//
//  PaymentRequestModel.swift
//
//
//  Created by Ruslan Kasian Dev on 20.09.2024.
//

import Foundation

// MARK: - PaymentApiConstants

struct PaymentApiConstants {
    static let modeDirect = "direct"
    static let modeHosted = "hosted"

    static let paymentMethodTypeApplePay = "apple_pay"
    static let paymentMethodTypeCardToken = "cc_token"
}

// MARK: - PaymentRequest

struct PaymentRequestModel: Encodable {
    let amount: Decimal
    let currency: String
    let externalId: String
    let callbackUrl: String?
    let resultUrl: String?
    let mode: String
    let customer: Customer

    private enum CodingKeys: String, CodingKey {
        case amount
        case currency
        case externalId = "external_id"
        case callbackUrl = "callback_url"
        case resultUrl = "result_url"
        case mode
        case customer
    }

    init(
        amountInCoins: Int64,
        currency: String,
        externalId: String,
        callbackUrl: String? = nil,
        resultUrl: String? = nil,
        mode: String = PaymentApiConstants.modeDirect,
        customer: Customer
    ) {
        self.amount = amountInCoins.currencyFormatAmount()
        self.currency = currency
        self.externalId = externalId
        self.callbackUrl = callbackUrl
        self.resultUrl = resultUrl
        self.mode = mode
        self.customer = customer
    }
}

// MARK: - Customer
struct Customer: Encodable {
    let paymentMethod: PaymentMethod

    private enum CodingKeys: String, CodingKey {
        case paymentMethod = "payment_method"
    }
}

// MARK: - PaymentMethod
struct PaymentMethod: Encodable {
    let type: String
    let applePay: ApplePay?
    let cardToken: CardToken?

    private enum CodingKeys: String, CodingKey {
        case type
        case applePay = "apple_pay"
        case cardToken = "cc_token"
    }

    // MARK: - Factory Methods
    static func applePay(_ applePay: ApplePay) -> PaymentMethod {
        return PaymentMethod(
            type: PaymentApiConstants.paymentMethodTypeApplePay,
            applePay: applePay,
            cardToken: nil
        )
    }

    static func cardToken(_ cardToken: CardToken) -> PaymentMethod {
        return PaymentMethod(
            type: PaymentApiConstants.paymentMethodTypeCardToken,
            applePay: nil,
            cardToken: cardToken
        )
    }
}

// MARK: - ApplePay
struct ApplePay: Encodable {
    let token: String
    let use3dsFlow: Bool

    private enum CodingKeys: String, CodingKey {
        case token
        case use3dsFlow = "use_3ds_flow"
    }

    init(token: String, use3dsFlow: Bool = true) {
        self.token = token
        self.use3dsFlow = use3dsFlow
    }
}

// MARK: - CardToken
struct CardToken: Encodable {
    let token: String
    let use3dsFlow: Bool

    private enum CodingKeys: String, CodingKey {
        case token
        case use3dsFlow = "use_3ds_flow"
    }

    init(token: String, use3dsFlow: Bool = true) {
        self.token = token
        self.use3dsFlow = use3dsFlow
    }
}
