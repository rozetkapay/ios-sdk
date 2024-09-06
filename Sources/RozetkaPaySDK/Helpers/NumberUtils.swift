//
//  NumberUtils.swift
//
//
//  Created by Ruslan Kasian Dev on 03.09.2024.
//

import Foundation

extension Double {
    
    func currencyFormat() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = RozetkaPaySdk.decimalSeparator
        return formatter.string(for: self) ?? self.description
    }
    
    func convertToCoinsAmount() -> Int64 {
        let amount = Double(self * 100).nextUp
        return Int64(amount)
    }
}

extension Int64 {
    
    func currencyFormatAmount() -> Double {
        return Double(self)/100.0
    }
    
    func currencyFormat() -> String {
        return (Double(self)/100.0).currencyFormat()
    }
    
}


extension NSNumber {
    var isBool: Bool {
        return type(of: self) == type(of: NSNumber(booleanLiteral: true))
    }
}
