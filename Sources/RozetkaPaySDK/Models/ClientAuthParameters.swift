//
//  ClientAuthParameters.swift
//  
//
//  Created by Ruslan Kasian Dev on 27.08.2024.
//

import Foundation

public protocol ClientAuthParametersProtocol: Codable {
    var key: String {get}
    var secondKey: String? {get}
}

public extension ClientAuthParametersProtocol {
    var secondKey: String? {
        return nil
    }
}

public struct ClientAuthParameters: ClientAuthParametersProtocol {
    public let key: String
    public let secondKey: String?
    
   public init(token: String, widgetKey: String) {
        self.key = token
        self.secondKey = widgetKey
    }
}
