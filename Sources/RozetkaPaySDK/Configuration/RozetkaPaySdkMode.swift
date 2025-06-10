//
//  RozetkaPaySdkMode.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 15.08.2024.
//  Copyright © 2024 RozetkaPay. All rights reserved.
//

import Foundation

/// Defines the operational mode of the RozetkaPay SDK.
///
/// Use `.production` for real payments and live environment,
/// and `.development` for testing and sandbox usage.
@frozen public enum RozetkaPaySdkMode: String {
    
    /// Production mode — used in the live environment with real transactions.
    case production
    
    /// Development mode — used for testing purposes and sandbox environments.
    case development
}
