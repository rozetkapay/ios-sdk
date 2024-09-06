//
//  ClientAuthParameters.swift
//  
//
//  Created by Ruslan Kasian Dev on 27.08.2024.
//

import Foundation

public struct ClientAuthParameters: Codable {
    let token: String
    
   public init(token: String) {
        self.token = token
    }
}
