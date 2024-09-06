//
//  CardExpirationDateValidationRule.swift
//
//
//  Created by Ruslan Kasian Dev on 27.08.2024.
//

import Foundation

public protocol CardExpirationDateValidationRule {
    func validate(currentDate: Date, expYear: Int, expMonth: Int) -> Bool
}

public struct DefaultCardExpirationDateValidationRule: CardExpirationDateValidationRule {
    public func validate(currentDate: Date, expYear: Int, expMonth: Int) -> Bool {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: currentDate) % 100
        let currentMonth = calendar.component(.month, from: currentDate)
        return expYear > currentYear || (expYear == currentYear && expMonth >= currentMonth)
    }
}

struct MinimalDateCardExpirationDateValidationRule: CardExpirationDateValidationRule {
    private let allowedMinimalDate: Date

    init(allowedMinimalDate: Date) {
        self.allowedMinimalDate = allowedMinimalDate
    }

    func validate(currentDate: Date, expYear: Int, expMonth: Int) -> Bool {
        let calendar = Calendar.current
        let minYear = calendar.component(.year, from: allowedMinimalDate) % 100
        let minMonth = calendar.component(.month, from: allowedMinimalDate)
        return expYear > minYear || (expYear == minYear && expMonth >= minMonth)
    }
}
