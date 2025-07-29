//
//  TokenizationFormResult.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 12.07.2025.
//
import Foundation

public typealias TokenizationFormResultCompletionHandler =  (TokenizationFormResult) -> Void

public enum TokenizationFormResult: Error, Decodable {
    case complete(tokenizedCard: TokenizedCard)
    case failed(error: TokenizationError)
    case cancelled
}

public typealias TokenizationFormUIStateCompletionHandler =  (TokenizationFormUIState) -> Void
public enum TokenizationFormUIState: Equatable {
    case startLoading
    case stopLoading
    case success
    case error(String)
}
