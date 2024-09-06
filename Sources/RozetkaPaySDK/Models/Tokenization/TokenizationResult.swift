//
//  TokenizationResult.swift
//  
//
//  Created by Ruslan Kasian Dev on 27.08.2024.
//

import Foundation

protocol TokenizationSheetResultCallback {
    func onTokenizationSheetResult(result: TokenizationResult)
}

public typealias TokenizationResult = Result<TokenizedCard, TokenizationError>

public enum TokenizationError: Error, Decodable {
    case failed(message: String?, errorDescription: String?)
    case cancelled

    private enum CodingKeys: String, CodingKey {
        case failed
        case cancelled
        case message
        case errorDescription = "error"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if container.contains(.failed) {
            let message = try container.decode(String?.self, forKey: .message)
            let errorDescription = try container.decode(String?.self, forKey: .errorDescription)
            self = .failed(message: message, errorDescription: errorDescription)
        } else {
            self = .cancelled
        }
    }
}
