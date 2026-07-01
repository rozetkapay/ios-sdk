//
//  TokenizationFormParameters.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 11.07.2025.
//
import Foundation

public struct TokenizationFormParameters: ParametersProtocol {
    /// Client authentication parameters.
    public let client: ClientAuthParametersProtocol
    
    public let viewParameters: ViewParametersProtocol
    
    /// Theme configuration for the payment UI.
    public let themeConfigurator: RozetkaPayThemeConfigurator
    
    /// Title shown on the dismiss button of the error screen. Defaults to `.cancel`.
    let errorDismissButtonTitle: ErrorDismissButtonTitle

    public init(
        client: ClientWidgetParameters,
        viewParameters: TokenizationFormViewParameters = TokenizationFormViewParameters(),
        themeConfigurator: RozetkaPayThemeConfigurator = RozetkaPayThemeConfigurator(),
        errorDismissButtonTitle: ErrorDismissButtonTitle = .cancel
    ) {
        self.client = client
        self.viewParameters = viewParameters
        self.themeConfigurator = themeConfigurator
        self.errorDismissButtonTitle = errorDismissButtonTitle
    }
}
