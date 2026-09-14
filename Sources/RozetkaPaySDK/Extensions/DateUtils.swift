//
//  DateUtils.swift
//
//
//  Created by Ruslan Kasian Dev on 08.09.2026.
//

import Foundation

extension Calendar {
    /// Gregorian UTC calendar for reading the components of a backend timestamp.
    static var rozetkaPayBackend: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? .current
        return calendar
    }
}

extension Date {
    /// Parses a backend timestamp of the form `yyyy-MM-dd'T'HH:mm:ss`, optionally followed by
    /// a fractional-seconds part and a time zone designator.
    ///
    /// - Parameter value: Timestamp to parse, for example `2126-02-12T12:13:02.207`.
    /// - Returns: The parsed date, or `nil` when `value` does not match the format. A value
    ///   without a designator is interpreted as UTC; `Z` and `±HH:MM` / `±HHMM` / `±HH` are honoured.
    static func fromBackendTimestamp(_ value: String) -> Date? {
        var rest = Substring(value.trimmingCharacters(in: .whitespaces))

        let timeZone = extractTimeZone(from: &rest)
        let fractionalSeconds = extractFractionalSeconds(from: &rest) ?? 0

        guard !rest.contains(".") else {
            return nil
        }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = timeZone ?? TimeZone(secondsFromGMT: 0)

        guard let date = formatter.date(from: String(rest)) else {
            return nil
        }

        return date.addingTimeInterval(fractionalSeconds)
    }

    /// Strips a trailing time zone designator.
    ///
    /// - Parameter value: Timestamp to read; the designator is removed when one is found.
    /// - Returns: The zone the designator denotes, or `nil` when there is none.
    private static func extractTimeZone(from value: inout Substring) -> TimeZone? {
        if value.last == "Z" || value.last == "z" {
            value = value.dropLast()
            return TimeZone(secondsFromGMT: 0)
        }

        guard let timePart = value.firstIndex(of: "T"),
              let signIndex = value[timePart...].lastIndex(where: { $0 == "+" || $0 == "-" })
        else {
            return nil
        }

        let sign = value[signIndex] == "-" ? -1 : 1
        let digits = value[value.index(after: signIndex)...].split(separator: ":").joined()

        guard digits.count == 2 || digits.count == 4,
              let hours = Int(digits.prefix(2))
        else {
            return nil
        }

        let minutes = Int(digits.dropFirst(2)) ?? 0

        value = value[..<signIndex]
        return TimeZone(secondsFromGMT: sign * (hours * 3600 + minutes * 60))
    }

    /// Strips a trailing fractional-seconds part.
    ///
    /// - Parameter value: Timestamp to read; the fractional part is removed when one is found.
    /// - Returns: The fractional part as a time interval, or `nil` when there is none.
    private static func extractFractionalSeconds(from value: inout Substring) -> TimeInterval? {
        guard let separator = value.lastIndex(of: ".") else {
            return nil
        }

        let digits = value[value.index(after: separator)...]

        guard !digits.isEmpty,
              digits.allSatisfy({ $0.isASCII && $0.isNumber }),
              let fraction = TimeInterval("0.\(digits)")
        else {
            return nil
        }

        value = value[..<separator]
        return fraction
    }
}
