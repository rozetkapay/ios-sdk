//
//  CardExpirationDate.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 15.08.2024.
//  Copyright © 2024 RozetkaPay. All rights reserved.
//

import Foundation

/// Errors, that can be encountered during expiration date parsing
public enum CardExpirationDateError: Error {
    case stringWrongLength
    case parsingError
}
/// Type that encapsulates expiration date
public struct CardExpirationDate: Equatable {
    let month: Int
    let year: Int
    
    var expirationDateStr: String {
        return "\(month.description)/\(year.description)"
    }
    
    public init(month: Int, year: Int) {
        self.month = month
        self.year = year
    }
    
    /// Fetches month and year from a raw string, if possible
    ///
    /// - parameter rawDateString:  Raw expiration date string.
    /// - Returns: `ExpirationDate`, if raw string could be converted, nil otherwise
    public init(rawDateString: String) throws {
        
        var month: Int?
        var year: Int?
        var indexEndMonth: String.Index
        var filteredDate = rawDateString
        
        if filteredDate.containsNonDigits {
            filteredDate = filteredDate.digitsOnly
        }

        guard filteredDate.count == 4 else {
            throw CardExpirationDateError.stringWrongLength
        }
        
        let monthString = String(filteredDate.prefix(2))
        let yearString = String(filteredDate.suffix(2))
        
        guard let month = Int(monthString), (1...12).contains(month) else {
            throw CardExpirationDateError.parsingError
        }
        
        guard let year = Int(yearString) else {
            throw CardExpirationDateError.parsingError
        }
        
        self.init(month: month, year: year)
    }
    
    public init?(rawString: String?) {
        guard let value = rawString else {
            return nil
        }
        
        do {
            try self.init(rawDateString: value)
        } catch  {
            return nil
        }
    }
}
