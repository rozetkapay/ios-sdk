//
//  PaymentResult.swift
//  
//
//  Created by Ruslan Kasian Dev on 27.08.2024.
//

import Foundation

public enum PaymentResult: Error, Decodable {
    case pending(orderId: String, paymentId: String)
    case complete(orderId: String, paymentId: String)
    case failed(paymentId: String?, message: String?, errorDescription: String?)
    case cancelled

    private enum CodingKeys: String, CodingKey {
        case pending
        case complete
        case failed
        case cancelled
        case orderId = "order_id"
        case paymentId = "payment_id"
        case message
        case errorDescription = "error"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if container.contains(.pending) {
            let orderId = try container.decode(String.self, forKey: .orderId)
            let paymentId = try container.decode(String.self, forKey: .paymentId)
            self = .pending(orderId: orderId, paymentId: paymentId)
        } else if container.contains(.complete) {
            let orderId = try container.decode(String.self, forKey: .orderId)
            let paymentId = try container.decode(String.self, forKey: .paymentId)
            self = .complete(orderId: orderId, paymentId: paymentId)
        } else if container.contains(.failed) {
            let paymentId = try container.decode(String?.self, forKey: .paymentId)
            let message = try container.decode(String?.self, forKey: .message)
            let errorDescription = try container.decode(String?.self, forKey: .errorDescription)
            self = .failed(paymentId: paymentId, message: message, errorDescription: errorDescription)
        } else {
            self = .cancelled
        }
    }
}
