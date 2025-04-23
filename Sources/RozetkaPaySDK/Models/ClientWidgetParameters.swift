//
//  ClientWidgetParameters.swift
//  
//
//  Created by Ruslan Kasian Dev on 27.08.2024.
//

import Foundation

public struct ClientWidgetParameters: ClientAuthParametersProtocol {
    public let key: String
    public let secondKey: String?
    
    public init(widgetKey: String) {
        self.key = widgetKey
        self.secondKey = nil
    }
}
