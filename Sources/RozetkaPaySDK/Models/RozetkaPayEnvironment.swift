//
//  RozetkaPayEnvironment.swift
//  
//
//  Created by Ruslan Kasian Dev on 27.08.2024.
//

import Foundation

public struct RozetkaPayEnvironment {
    let tokenizationApiProviderUrl: String
    let paymentsApiProviderUrl: String
    let paymentsConfirmation3DsCallbackUrl: String
    let timeInterval: TimeInterval
    
    public init(
        tokenizationApiProviderUrl: String,
        paymentsApiProviderUrl: String,
        paymentsConfirmation3DsCallbackUrl: String,
        timeInterval: TimeInterval = 60.0
    ) {
        self.tokenizationApiProviderUrl = tokenizationApiProviderUrl
        self.paymentsApiProviderUrl = paymentsApiProviderUrl
        self.paymentsConfirmation3DsCallbackUrl = paymentsConfirmation3DsCallbackUrl
        self.timeInterval = timeInterval
    }
}
