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
    
    func convertToInt64() -> Int64 {
        return Int64(self)
    }
}

extension Int64 {
    
    func currencyFormatAmount() -> Double {
        return Double(self)/100.0
    }
    
    func currencyFormatAmount() -> Decimal {
        return Decimal(self)/100.0
    }
    
    func currencyFormat() -> String {
        return (Double(self)/100.0).currencyFormat()
    }
    
    func convertToCoinsAmount() -> Int64 {
        return Double(self).convertToCoinsAmount()
    }
}


extension NSNumber {
    var isBool: Bool {
        return type(of: self) == type(of: NSNumber(booleanLiteral: true))
    }
}


extension Optional where Wrapped == Double {
    var isNilOrEmpty: Bool {
        self == nil || self == 0
    }
    
    var isNilOrEmptyValue: Double? {
        if self == nil || self == 0 {
            return nil
        }else{
            return self
        }
    }
}

extension Optional where Wrapped == Int {
    var isNilOrEmpty: Bool {
        self == nil || self == 0
    }
    
    var isNilOrEmptyValue: Int? {
        if self == nil || self == 0 {
            return nil
        }else{
            return self
        }
    }
}

extension Optional where Wrapped == Int64 {
    var isNilOrEmpty: Bool {
        self == nil || self == 0
    }
    
    var isNilOrEmptyValue: Int64? {
        if self == nil || self == 0 {
            return nil
        }else{
            return self
        }
    }
}

extension Optional where Wrapped == CGFloat {
    var isNilOrEmpty: Bool {
        self == nil || self == 0
    }
    
    var isNilOrEmptyValue: CGFloat? {
        if self == nil || self == 0 {
            return nil
        }else{
            return self
        }
    }
}

extension Double {
    var isEmpty: Bool {
        self == 0
    }
    
    var isEmptyOrValue: Double? {
        if self == 0 {
            return nil
        } else {
            return self
        }
    }
}

extension Int {
    var isEmpty: Bool {
        self == 0
    }
    
    var isEmptyOrValue: Int? {
        if self == 0 {
            return nil
        } else {
            return self
        }
    }
}

extension Int64 {
    var isEmpty: Bool {
        self == 0
    }
    
    var isEmptyOrValue: Int64? {
        if self == 0 {
            return nil
        } else {
            return self
        }
    }
}

extension CGFloat {
    var isNilOrEmpty: Bool {
        self == 0
    }
    
    var isEmptyOrValue: CGFloat? {
        if self == 0 {
            return nil
        } else {
            return self
        }
    }
}
