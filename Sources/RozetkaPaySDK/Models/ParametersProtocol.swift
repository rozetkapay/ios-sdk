//
//  ParametersProtocol.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 28.05.2025.
//
import Foundation

public protocol ParametersProtocol {
    var client: ClientAuthParametersProtocol {get}
    var viewParameters: ViewParametersProtocol {get}
    var themeConfigurator: RozetkaPayThemeConfigurator {get}
}
