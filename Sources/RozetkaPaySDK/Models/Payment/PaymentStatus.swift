//
//  PaymentStatus.swift
//
//
//  Created by Ruslan Kasian Dev on 27.08.2024.
//

import Foundation

public enum PaymentStatus: String {
    case start = "init"
    case pending
    case success
    case failure
    
    var isTerminated: Bool {
        return self == .success || self == .failure
    }
}

