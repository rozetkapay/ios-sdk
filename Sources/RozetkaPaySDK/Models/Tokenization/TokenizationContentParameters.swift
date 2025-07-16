//
//  TokenizationContentParameters.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 11.07.2025.
//
import Foundation

public struct TokenizationContentParameters: ParametersProtocol {
    public let client: ClientAuthParametersProtocol
    public let viewParameters: ViewParametersProtocol
    public let themeConfigurator: RozetkaPayThemeConfigurator
    
    public init(
        client: ClientWidgetParameters,
        viewParameters: TokenizationContentViewParameters = TokenizationContentViewParameters(),
        themeConfigurator: RozetkaPayThemeConfigurator = RozetkaPayThemeConfigurator()
    ) {
        self.client = client
        self.viewParameters = viewParameters
        self.themeConfigurator = themeConfigurator
    }
}
