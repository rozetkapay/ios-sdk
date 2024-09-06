//
//  File.swift
//  
//
//  Created by Ruslan Kasian Dev on 05.09.2024.
//

import Foundation

public struct RozetkaPayTokenizationException: Error {
    let id: String
    let errorMessage: String

    init(id: String, errorMessage: String) {
        self.id = id
        self.errorMessage = errorMessage
    }

    var localizedDescription: String {
        return "\(id): \(errorMessage)"
    }
}
