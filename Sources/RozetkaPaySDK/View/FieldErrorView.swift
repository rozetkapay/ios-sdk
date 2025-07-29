//
//  FieldErrorView.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 24.07.2025.
//


import SwiftUI

struct FieldErrorView: View {
    //MARK: - Properties
    @Environment(\.colorScheme) var colorScheme
    private let themeConfigurator: RozetkaPayThemeConfigurator
    private let message: String

    init(
        message: String,
        _ themeConfigurator: RozetkaPayThemeConfigurator
    ) {
        self.message = message
        self.themeConfigurator = themeConfigurator
    }
    
    var body: some View {
        Text(message)
            .font(
                themeConfigurator
                    .typography
                    .labelSmall
            )
            .foregroundColor(
                themeConfigurator
                    .colorScheme(colorScheme)
                    .error
            )
            .multilineTextAlignment(.leading)
            .padding(.top, 10)
            .padding([.leading, .trailing], 14)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    FieldErrorView(
        message: "Error message, Error message , Error message, Error message",
        RozetkaPayThemeConfigurator()
    )
}
