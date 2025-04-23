//
//  EnvironmentProvider.swift
//
//
//  Created by Ruslan Kasian Dev on 05.09.2024.
//

import Foundation

protocol EnvironmentProviderProtocol {
   static var environment: RozetkaPayEnvironment { get }
}

class EnvironmentProvider: EnvironmentProviderProtocol {
   static var environment: RozetkaPayEnvironment {
        switch RozetkaPaySdk.mode {
        case .production:
            return RozetkaPayConfig.prodEnvironment
        case .development:
            return RozetkaPayConfig.devEnvironment
        }
    }
}
