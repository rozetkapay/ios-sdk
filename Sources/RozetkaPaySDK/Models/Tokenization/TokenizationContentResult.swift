//
//  TokenizationContentResult.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 12.07.2025.
//
import Foundation

public typealias TokenizationContentResultCompletionHandler =  (TokenizationContentResult) -> Void

public enum TokenizationContentResult: Error, Decodable {
    case complete(tokenizedCard: TokenizedCard)
    case failed(error: TokenizationError)
    case cancelled
}

public typealias TokenizationContentUIStateCompletionHandler =  (TokenizationContentUIState) -> Void
public enum TokenizationContentUIState: Equatable {
    case startLoading
    case stopLoading
    case success
    case error(String)
}
