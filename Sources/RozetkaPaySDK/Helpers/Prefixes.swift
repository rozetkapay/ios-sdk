//
//  Prefixes.swift
//  
//
//  Created by Ruslan Kasian Dev on 27.08.2024.
//

import Foundation

/// A protocol that defines a method to check if a given value matches a prefix.
protocol PrefixContainable {
    /// Checks whether the given integer value matches the prefix defined by the conforming type.
    ///
    /// - Parameter value: The integer value to be checked.
    /// - Returns: `true` if the value matches the prefix; otherwise, `false`.
    func contains(_ value: Int) -> Bool
}

/// A structure that represents a prefix as a fixed integer.
struct PrefixInt: PrefixContainable {
    /// The fixed integer prefix.
    let prefix: Int
    
    /// Checks whether the given integer value starts with the specified integer prefix.
    ///
    /// - Parameter value: The integer value to be checked.
    /// - Returns: `true` if the value starts with the integer prefix; otherwise, `false`.
    func contains(_ value: Int) -> Bool {
        return String(value).hasPrefix(String(prefix))
    }
}

/// A structure that represents a prefix as a range of integers.
struct PrefixRange: PrefixContainable {
    /// The range of valid integer prefixes.
    let range: ClosedRange<Int>
    
    /// Checks whether the given integer value falls within the specified range prefix.
    ///
    /// - Parameter value: The integer value to be checked.
    /// - Returns: `true` if the value matches any prefix within the range; otherwise, `false`.
    func contains(_ value: Int) -> Bool {
        // Determine the length of the prefix based on the lower bound of the range
        let valuePrefixLength = String(range.lowerBound).count
        
        // Extract the prefix from the input value and check if it falls within the range
        if let valuePrefix = Int(String(value).prefix(valuePrefixLength)) {
            return range.contains(valuePrefix)
        }
        return false
    }
}

