//
//  File.swift
//  
//
//  Created by Ruslan Kasian Dev on 05.09.2024.
//

import Foundation

protocol EnvironmentProvider {
   static var environment: RozetkaPayEnvironment { get }
}

// Implementation of EnvironmentProvider
class EnvironmentProviderImpl: EnvironmentProvider {
   static var environment: RozetkaPayEnvironment {
        switch RozetkaPaySdk.mode {
        case .production:
            return RozetkaPayConfig.prodEnvironment
        case .development:
            return RozetkaPayConfig.devEnvironment
        }
    }
}
