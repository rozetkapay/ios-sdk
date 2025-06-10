//
//  PaymentResult.swift
//  
//
//  Created by Ruslan Kasian Dev on 27.08.2024.
//

import Foundation

public typealias PaymentResultCompletionHandler =  (PaymentResult) -> Void

public enum PaymentResult: Error, Decodable {
    case pending(externalId: String, paymentId: String?, message: String?, error: PaymentError?)
    case complete(externalId: String, paymentId: String, tokenizedCard: TokenizedCard?)
    case failed(error: PaymentError)
    case cancelled(externalId: String?, paymentId: String?)
}
