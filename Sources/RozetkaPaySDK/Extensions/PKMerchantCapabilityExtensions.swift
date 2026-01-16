//
//  File.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 16.01.2026.
//

import Foundation
import PassKit

extension PKMerchantCapability: CustomDebugStringConvertible {
    public var debugDescription: String {
        var capabilities: [String] = []
        
        if #available(iOS 17.0, *) {
            if contains(.threeDSecure) { capabilities.append("3DS") }
            if contains(.debit) { capabilities.append("Debit") }
            if contains(.credit) { capabilities.append("Credit") }
            if contains(.emv) { capabilities.append("EMV") }
            if contains(.instantFundsOut) { capabilities.append("InstantFundsOut") }
        } else {
            if contains(.capability3DS) { capabilities.append("3DS") }
            if contains(.capabilityDebit) { capabilities.append("Debit") }
            if contains(.capabilityCredit) { capabilities.append("Credit") }
            if contains(.capabilityEMV) { capabilities.append("EMV") }
        }
        
        return capabilities.isEmpty ? "none" : capabilities.joined(separator: ", ")
    }
}
