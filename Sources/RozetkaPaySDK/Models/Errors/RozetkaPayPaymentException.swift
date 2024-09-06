//
//  RozetkaPayPaymentException 2.swift
//
//
//  Created by Ruslan Kasian Dev on 05.09.2024.
//

import Foundation

public struct RozetkaPayPaymentException: Error {
    let code: String
    let errorMessage: String
    let type: String?

    public init(code: String, errorMessage: String, type: String? = nil) {
        self.code = code
        self.errorMessage = errorMessage
        self.type = type
    }

    var localizedDescription: String {
        return "code = \(code), type = \(type ?? "nil"), message = \(errorMessage)"
    }
}
