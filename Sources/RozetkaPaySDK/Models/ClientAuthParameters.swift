//
//  ClientAuthParameters.swift
//  
//
//  Created by Ruslan Kasian Dev on 27.08.2024.
//

import Foundation

public struct ClientAuthParameters: ClientAuthParametersProtocol {
    public let key: String
    
   public init(token: String) {
        self.key = token
    }
}
