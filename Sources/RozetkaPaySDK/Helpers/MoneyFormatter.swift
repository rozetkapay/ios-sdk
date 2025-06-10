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
    public static var rawFormatters: [Int: NumberFormatter] = [:]

    /// Formats a given coin value to a money string representation for UI.
    ///
    /// - Parameters:
    ///   - coins: The value in coins to be formatted.
    ///   - currency: An optional currency string to append (e.g. "UAH").
    ///   - exponent: The exponent to define the decimal places (default is 2).
    /// - Returns: The formatted money string (e.g. "1 400.00 UAH").
    public static func formatCoinsToMoney(coins: Decimal, currency: String? = nil, exponent: Int = defaultExponent) -> String {
        let money = coins * getCoinMultiplier(for: exponent)
        return formatMoney(money: money, currency: currency, exponent: exponent)
    }

    /// Formats a given coin value to a money string representation for UI.
    ///
    /// - Parameters:
    ///   - coins: The value in coins to be formatted.
    ///   - currency: An optional currency string to append.
    ///   - exponent: The exponent to define the decimal places.
    /// - Returns: The formatted money string.
    public static func formatCoinsToMoney(coins: Int64, currency: String? = nil, exponent: Int = defaultExponent) -> String {
        return formatCoinsToMoney(coins: Decimal(coins), currency: currency, exponent: exponent)
    }

    /// Formats a given money value to a string representation for UI.
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

    /// Formats a coin value to a raw money string representation **without grouping separators**.
    ///
    /// Use this for internal calculations or payment APIs (e.g. Apple Pay), where grouping (like spaces) is not allowed.
    ///
    /// - Parameters:
    ///   - coins: The value in coins (e.g. 1400000 for 14,000.00).
    ///   - exponent: The exponent to define the decimal places.
    /// - Returns: A plain numeric string (e.g. "14000.00") suitable for `NSDecimalNumber(string:)`.
    public static func formatCoinsToRawMoneyString(coins: Int64, exponent: Int = defaultExponent) -> String {
        let money = Decimal(coins) * getCoinMultiplier(for: exponent)
        return getRawFormatter(for: exponent).string(from: money as NSDecimalNumber) ?? "\(money)"
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

    /// Returns a cached `NumberFormatter` with grouping separators or creates a new one if not available.
    ///
    /// - Parameter exponent: The exponent for decimal places.
    /// - Returns: A `NumberFormatter` configured for UI formatting.
    private static func getFormatter(for exponent: Int) -> NumberFormatter {
        if let formatter = formatters[exponent] {
            return formatter
        } else {
            let newFormatter = generateFormatter(for: exponent, usesGroupingSeparator: true)
            formatters[exponent] = newFormatter
            return newFormatter
        }
    }

    /// Returns a cached `NumberFormatter` **without** grouping separators or creates a new one if not available.
    ///
    /// - Parameter exponent: The exponent for decimal places.
    /// - Returns: A `NumberFormatter` configured for raw formatting (Apple Pay, APIs).
    private static func getRawFormatter(for exponent: Int) -> NumberFormatter {
        if let formatter = rawFormatters[exponent] {
            return formatter
        } else {
            let newFormatter = generateFormatter(for: exponent, usesGroupingSeparator: false)
            rawFormatters[exponent] = newFormatter
            return newFormatter
        }
    }

    /// Generates a `NumberFormatter` based on the given exponent and separator config.
    ///
    /// - Parameters:
    ///   - exponent: The exponent for decimal places.
    ///   - usesGroupingSeparator: Whether to use grouping separators (e.g. space for thousands).
    /// - Returns: A configured `NumberFormatter`.
    private static func generateFormatter(for exponent: Int, usesGroupingSeparator: Bool) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = usesGroupingSeparator ? " " : ""
        formatter.decimalSeparator = String(decimalSeparator)
        formatter.minimumFractionDigits = exponent
        formatter.maximumFractionDigits = exponent
        return formatter
    }
}
