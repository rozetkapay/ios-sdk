//
//  MoneyFormatter.swift
//  
//
//  Created by Ruslan Kasian Dev on 03.09.2024.
//

import Foundation

/// Utility for formatting money values.
public final class MoneyFormatter {
    public static let decimalSeparator: Character = "."
    public static let defaultExponent: Int = 2
    public static var formatters: [Int: NumberFormatter] = [:]

    /// Formats a given coin value to a money string representation.
    ///
    /// - Parameters:
    ///   - coins: The value in coins to be formatted.
    ///   - currency: An optional currency string to append.
    ///   - exponent: The exponent to define the decimal places.
    /// - Returns: The formatted money string.
    public static func formatCoinsToMoney(coins: Decimal, currency: String? = nil, exponent: Int = defaultExponent) -> String {
        let money = coins * getCoinMultiplier(for: exponent)
        return formatMoney(money: money, currency: currency, exponent: exponent)
    }

    /// Formats a given coin value to a money string representation.
    ///
    /// - Parameters:
    ///   - coins: The value in coins to be formatted.
    ///   - currency: An optional currency string to append.
    ///   - exponent: The exponent to define the decimal places.
    /// - Returns: The formatted money string.
    public static func formatCoinsToMoney(coins: Int64, currency: String? = nil, exponent: Int = defaultExponent) -> String {
        return formatCoinsToMoney(coins: Decimal(coins), currency: currency, exponent: exponent)
    }

    /// Formats a given money value to a string representation.
    ///
    /// - Parameters:
    ///   - money: The monetary value to be formatted.
    ///   - currency: An optional currency string to append.
    ///   - exponent: The exponent to define the decimal places.
    /// - Returns: The formatted money string.
    public static func formatMoney(money: Decimal, currency: String? = nil, exponent: Int = defaultExponent) -> String {
        let sign = money < 0 ? "-" : ""
        let currencySuffix = currency != nil ? " \(currency!)" : ""
        let formattedMoney = getFormatter(for: exponent).string(from: money.magnitude as NSDecimalNumber) ?? "\(money)"
        return "\(sign)\(formattedMoney)\(currencySuffix)"
    }

    /// Calculates the coin multiplier based on the exponent.
    ///
    /// - Parameter exponent: The exponent for decimal places.
    /// - Returns: A `Decimal` multiplier to convert coins to money.
    private static func getCoinMultiplier(for exponent: Int) -> Decimal {
        guard exponent >= 0 else {
            fatalError("Exponent can't be less than zero")
        }
        let divisor = pow(10.0, exponent)
        return Decimal(1) / divisor
    }

    /// Returns a cached `NumberFormatter` or creates a new one if not available.
    ///
    /// - Parameter exponent: The exponent for decimal places.
    /// - Returns: A `NumberFormatter` configured for the given exponent.
    private static func getFormatter(for exponent: Int) -> NumberFormatter {
        if let formatter = formatters[exponent] {
            return formatter
        } else {
            let newFormatter = generateFormatter(for: exponent)
            formatters[exponent] = newFormatter
            return newFormatter
        }
    }

    /// Generates a `NumberFormatter` based on the given exponent.
    ///
    /// - Parameter exponent: The exponent for decimal places.
    /// - Returns: A `NumberFormatter` configured for the given exponent.
    private static func generateFormatter(for exponent: Int) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = String(decimalSeparator)
        formatter.minimumFractionDigits = exponent
        formatter.maximumFractionDigits = exponent
        return formatter
    }
}
