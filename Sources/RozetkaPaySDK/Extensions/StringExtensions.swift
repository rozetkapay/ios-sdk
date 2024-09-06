//
//  StringExtensions.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 15.08.2024.
//  Copyright © 2024 RozetkaPay. All rights reserved.
//

import Foundation

public extension String {
    var digitsOnly: String {
        return filter { $0.isNumber }
    }
    
    var containsNonDigits: Bool {
        return !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(
                charactersIn: self
            )
        )
    }
}
