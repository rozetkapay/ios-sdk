//
//  TokenizationResult.swift
//  
//
//  Created by Ruslan Kasian Dev on 27.08.2024.
//

import Foundation

public typealias TokenizationResultCompletionHandler = (TokenizationResult) -> Void
public typealias TokenizationResult = Result<TokenizedCard, TokenizationError>
