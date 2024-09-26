//
//  File.swift
//
//
//  Created by Ruslan Kasian Dev on 10.09.2024.
//

import SwiftUI

struct ErrorView: View {
    @Environment(\.colorScheme) var colorScheme
    private let themeConfigurator: RozetkaPayThemeConfigurator
    
    var errorMessage: String
    var onCancel: () -> Void
    var onRetry: () -> Void
    
    init(
        themeConfigurator: RozetkaPayThemeConfigurator,
        errorMessage: String? = nil,
        onCancel: @escaping () -> Void,
        onRetry: @escaping () -> Void
    ) {
        self.themeConfigurator = themeConfigurator
        self.errorMessage = errorMessage ?? Localization.rozetka_pay_tokenization_error_common.description
        self.onCancel = onCancel
        self.onRetry = onRetry
    }
    
    var body: some View {
        VStack {
            Spacer()
            imageView
            errorMessageView
            // Buttons
            VStack(spacing: 16) {
                secondButton
                mainButton
                .padding(.horizontal, 20)
            }
            
            Spacer()
        }
        .background(
            themeConfigurator
            .colorScheme(colorScheme)
            .surface
        )
        .cornerRadius(
            themeConfigurator
                .sizes
                .sheetCornerRadius
        )
        .padding()
    }
    
    private var imageView: some View {
        Image("rozetka_pay_error", bundle: .module)
            .resizable()
            .frame(width: 200, height: 200)
            .padding()
        
    }
    
    private var errorMessageView: some View {
        Text(errorMessage)
            .font(
                themeConfigurator
                    .typography
                    .body
                
            )
            .multilineTextAlignment(.center)
            .padding(.horizontal)
            .padding(.bottom, 20)
        
    }
    
    private var mainButton: some View {
        Button(action: {
            onRetry()
        }) {
            Text(Localization.rozetka_pay_common_button_retry.description)
                .font(
                    themeConfigurator
                        .typography
                        .labelLarge
                )
                .bold()
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(
                   themeConfigurator
                        .colorScheme(colorScheme)
                        .onPrimary
                    
                )
                .background(
                    themeConfigurator
                        .colorScheme(colorScheme)
                        .primary
                )
                .cornerRadius(
                    themeConfigurator
                        .sizes
                        .buttonCornerRadius
                )
        }
        .padding(.top, 20)
    }
    
    private var secondButton: some View {
        Button(action: {
            onCancel()
        }) {
            Text(Localization.rozetka_pay_common_button_cancel.description)
                .font(
                    themeConfigurator
                        .typography
                        .labelLarge
                )
                .bold()
                .foregroundColor(
                   themeConfigurator
                        .colorScheme(colorScheme)
                        .primary
                    
                )
        }
        .padding(.top, 20)
    }
}

#Preview {
    ErrorView(
        themeConfigurator: RozetkaPayThemeConfigurator(), 
//        errorMessage: "test",
        onCancel: { print("Cancel tapped") },
        onRetry: { print("Retry tapped") }
    )
}
