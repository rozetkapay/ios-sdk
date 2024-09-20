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

// MARK: - PaymentRequestDto

struct PaymentRequestModel: Encodable {
    let amount: Double
    let currency: String
    let externalId: String
    let callbackUrl: String?
    let mode: String
    let customer: CustomerDto

    enum CodingKeys: String, CodingKey {
        case amount
        case currency
        case externalId = "external_id"
        case callbackUrl = "callback_url"
        case mode
        case customer
    }

    init(
        amount: Double,
        currency: String,
        externalId: String,
        callbackUrl: String? = nil,
        mode: String = PaymentApiConstants.modeDirect,
        customer: CustomerDto
    ) {
        self.amount = amount
        self.currency = currency
        self.externalId = externalId
        self.callbackUrl = callbackUrl
        self.mode = mode
        self.customer = customer
    }
}

// MARK: - CustomerDto

struct CustomerDto: Encodable {
    let paymentMethod: PaymentMethodDto

    enum CodingKeys: String, CodingKey {
        case paymentMethod = "payment_method"
    }
}

// MARK: - PaymentMethodDto

struct PaymentMethodDto: Encodable {
    let type: String
    let applePay: ApplePayDto?
    let cardToken: CardTokenDto?

    enum CodingKeys: String, CodingKey {
        case type
        case applePay = "apple_pay"
        case cardToken = "cc_token"
    }

    // MARK: - Factory Methods

    static func applePay(_ applePay: ApplePayDto) -> PaymentMethodDto {
        return PaymentMethodDto(
            type: PaymentApiConstants.paymentMethodTypeApplePay,
            applePay: applePay,
            cardToken: nil
        )
    }

    static func cardToken(_ cardToken: CardTokenDto) -> PaymentMethodDto {
        return PaymentMethodDto(
            type: PaymentApiConstants.paymentMethodTypeCardToken,
            applePay: nil,
            cardToken: cardToken
        )
    }
}

// MARK: - ApplePayDto

struct ApplePayDto: Encodable {
    let token: String
    let use3dsFlow: Bool

    enum CodingKeys: String, CodingKey {
        case token
        case use3dsFlow = "use_3ds_flow"
    }

    init(token: String, use3dsFlow: Bool = true) {
        self.token = token
        self.use3dsFlow = use3dsFlow
    }
}

// MARK: - CardTokenDto

struct CardTokenDto: Encodable {
    let token: String
    let use3dsFlow: Bool

    enum CodingKeys: String, CodingKey {
        case token
        case use3dsFlow = "use_3ds_flow"
    }

    init(token: String, use3dsFlow: Bool = true) {
        self.token = token
        self.use3dsFlow = use3dsFlow
    }
}
