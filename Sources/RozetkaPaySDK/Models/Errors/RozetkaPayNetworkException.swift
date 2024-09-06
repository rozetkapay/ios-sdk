//
//  RozetkaPayNetworkException.swift
//
//
//  Created by Ruslan Kasian Dev on 05.09.2024.
//

import Foundation

public struct RozetkaPayNetworkException: Error {
    let message: String?
    let cause: Error?

    init(message: String? = nil, cause: Error? = nil) {
        self.message = message
        self.cause = cause
    }

    var localizedDescription: String {
        return message ?? "An error occurred"
    }
}


