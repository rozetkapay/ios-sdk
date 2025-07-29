//
//  TokenizationResult.swift
//  
//
//  Created by Ruslan Kasian Dev on 27.08.2024.
//

import Foundation

public typealias TokenizationResultCompletionHandler =  (TokenizationResult) -> Void

public enum TokenizationResult: Error, Decodable {
    case complete(tokenizedCard: TokenizedCard)
    case failed(error: TokenizationError)
    case cancelled
}
