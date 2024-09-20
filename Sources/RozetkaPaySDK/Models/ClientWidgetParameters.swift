//
//  ClientWidgetParameters.swift
//  
//
//  Created by Ruslan Kasian Dev on 27.08.2024.
//

import Foundation

public protocol ClientAuthParametersProtocol: Codable {
    var key: String {get}
}

public struct ClientWidgetParameters: ClientAuthParametersProtocol {
    public let key: String
    
    public init(widgetKey: String) {
        self.key = widgetKey
    }
}
