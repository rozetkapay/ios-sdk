//
//  Currency.swift
//
//
//  Created by Ruslan Kasian Dev on 20.08.2024.
//

import Foundation

enum Currency {
    case UAH
    case USD
    case EUR
    case GBP
    case PLN
    case CHF

    static var defaultCode: String {
        return "UAH"
    }
    
    var codes: [String] {
        switch self {
        case .UAH: 
            return ["UAH"]
        case .USD: 
            return ["USD"]
        case .EUR:
            return ["EUR"]
        case .GBP: 
            return ["GBP"]
        case .PLN: 
            return ["PLN"]
        case .CHF: 
            return ["CHF"]
        }
    }

    var symbol: String {
        switch self {
        case .UAH: 
            return "₴"
        case .USD: 
            return "$"
        case .EUR: 
            return "€"
        case .GBP: 
            return "£"
        case .PLN: 
            return "zł"
        case .CHF: 
            return "₣"
        }
    }

    private static var codesMap: [String: Currency] = {
        var map = [String: Currency]()
        Currency.allCases.forEach { currency in
            currency.codes.forEach { code in
                map[code.uppercased()] = currency
            }
        }
        return map
    }()

    static func getSymbol(currencyCode: String?) -> String {
        return getCurrency(currencyCode: currencyCode)?.symbol ?? currencyCode ?? ""
    }

    static func getCurrency(currencyCode: String?) -> Currency? {
        guard let code = currencyCode?.uppercased() else {
            return nil
        }
        return codesMap[code]
    }
}

extension Currency: CaseIterable {}
