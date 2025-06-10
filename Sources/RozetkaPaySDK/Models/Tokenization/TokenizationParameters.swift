//
//  TokenizationParameters.swift
//
//
//  Created by Ruslan Kasian Dev on 27.08.2024.
//

import Foundation

public struct TokenizationParameters: ParametersProtocol {
    public let client: ClientAuthParametersProtocol
    public let viewParameters: ViewParametersProtocol
    public let themeConfigurator: RozetkaPayThemeConfigurator
    
    public init(
        client: ClientWidgetParameters,
        viewParameters: TokenizationViewParameters = TokenizationViewParameters(),
        themeConfigurator: RozetkaPayThemeConfigurator = RozetkaPayThemeConfigurator()
    ) {
        self.client = client
        self.viewParameters = viewParameters
        self.themeConfigurator = themeConfigurator
    }
}
