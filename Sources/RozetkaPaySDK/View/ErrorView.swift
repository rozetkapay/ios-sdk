//
//  File.swift
//
//
//  Created by Ruslan Kasian Dev on 10.09.2024.
//

import SwiftUI

struct ErrorView: View {
    //MARK: - Properties
    @Environment(\.colorScheme) var colorScheme
    private let themeConfigurator: RozetkaPayThemeConfigurator
    
    private var errorMessage: String
    private var onCancel: () -> Void
    private var onRetry: () -> Void
    private var isButtonRetryEnabled: Bool
    
    //MARK: - Init
    init(
        themeConfigurator: RozetkaPayThemeConfigurator,
        errorMessage: String? = nil,
        onCancel: @escaping () -> Void,
        onRetry: @escaping () -> Void = {},
        isButtonRetryEnabled: Bool = true
    ) {
        self.themeConfigurator = themeConfigurator
        self.errorMessage = errorMessage ?? Localization.rozetka_pay_tokenization_error_common.description
        self.onCancel = onCancel
        self.onRetry = onRetry
        self.isButtonRetryEnabled = isButtonRetryEnabled
    }
    
    //MARK: - Body
    var body: some View {
        VStack {
            Spacer()
            imageView
            errorMessageView
            if isButtonRetryEnabled{
                buttons
            }else {
                mainButton
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
    
}

//MARK: UI
private extension ErrorView {
    
    ///
    var imageView: some View {
        DomainImages.payError.image()
            .resizable()
            .frame(width: 200, height: 200)
            .padding()
        
    }
    
    ///
    var errorMessageView: some View {
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
    
    ///
    var buttons: some View {
        VStack(spacing: 16) {
            secondButton
            mainButton
                .padding(.horizontal, 20)
        }
    }
    
    ///
    var mainButton: some View {
        Button(action: {
            if isButtonRetryEnabled {
                onRetry()
            } else {
                onCancel()
            }
        }) {
            Text(isButtonRetryEnabled ? Localization.rozetka_pay_common_button_retry.description :
                Localization.rozetka_pay_common_button_cancel.description
            )
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
    
    ///
    var secondButton: some View {
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

//MARK: - Preview
#Preview {
    ErrorView(
        themeConfigurator: RozetkaPayThemeConfigurator(),
        errorMessage: "test",
        onCancel: { print("Cancel tapped") },
        onRetry: { print("Retry tapped") }
    )
}
