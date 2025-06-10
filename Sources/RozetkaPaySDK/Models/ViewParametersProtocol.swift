//
//  ViewParametersProtocol.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 28.05.2025.
//
import Foundation

public protocol ViewParametersProtocol {
    var cardNameField: FieldRequirement { get}
    var emailField: FieldRequirement { get }
    var cardholderNameField: FieldRequirement {get}
}
