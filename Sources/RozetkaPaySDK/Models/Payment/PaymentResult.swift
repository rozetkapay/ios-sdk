//
//  PaymentResult.swift
//  
//
//  Created by Ruslan Kasian Dev on 27.08.2024.
//

import Foundation

public typealias PaymentResultCompletionHandler =  (PaymentResult) -> Void

public enum PaymentResult: Error, Decodable {
    case pending(orderId: String, paymentId: String?, message: String?, error: PaymentError?)
    case complete(orderId: String, paymentId: String)
    case failed(error: PaymentError)
    case cancelled(orderId: String?, paymentId: String?)
}
