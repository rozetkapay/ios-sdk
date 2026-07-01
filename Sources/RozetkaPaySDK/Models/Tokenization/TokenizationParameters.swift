//
//  TokenizationParameters.swift
//
//
//  Created by Ruslan Kasian Dev on 27.08.2024.
//

import Foundation

public struct TokenizationParameters: ParametersProtocol {
    /// Client authentication parameters.
    public let client: ClientAuthParametersProtocol
    
    public let viewParameters: ViewParametersProtocol
    
    /// Theme configuration for the payment UI.
    public let themeConfigurator: RozetkaPayThemeConfigurator
    
    /// Title shown on the dismiss button of the error screen. Defaults to `.close`.
    let errorDismissButtonTitle: ErrorDismissButtonTitle

    public init(
        client: ClientWidgetParameters,
        viewParameters: TokenizationViewParameters = TokenizationViewParameters(),
        themeConfigurator: RozetkaPayThemeConfigurator = RozetkaPayThemeConfigurator(),
        errorDismissButtonTitle: ErrorDismissButtonTitle = .close
    ) {
        self.client = client
        self.viewParameters = viewParameters
        self.themeConfigurator = themeConfigurator
        self.errorDismissButtonTitle = errorDismissButtonTitle
    }
}
