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
    private var cancelButtonTitle: String
    private var isButtonRetryEnabled: Bool
    private var isExpanded: Bool
    private let accessibilityNamespace: String
    private var tags: AccessibilityTag.Error {
        AccessibilityTag.Error(namespace: accessibilityNamespace)
    }
    
    //MARK: - Init
    init(
        accessibilityNamespace: String,
        themeConfigurator: RozetkaPayThemeConfigurator,
        errorMessage: String? = nil,
        onCancel: @escaping () -> Void,
        onRetry: @escaping () -> Void = {},
        cancelButtonTitle: String? = nil,
        isButtonRetryEnabled: Bool = true,
        isExpanded: Bool = false
    ) {
        self.accessibilityNamespace = accessibilityNamespace
        self.themeConfigurator = themeConfigurator
        self.errorMessage = errorMessage ?? Localization.rozetka_pay_tokenization_error_common.description
        self.onCancel = onCancel
        self.onRetry = onRetry
        self.cancelButtonTitle = cancelButtonTitle ?? Localization.rozetka_pay_common_button_cancel.description
        self.isButtonRetryEnabled = isButtonRetryEnabled
        self.isExpanded = isExpanded
    }
    
    //MARK: - Body
    
    var body: some View {
        contentView
    }
}

//MARK: UI
private extension ErrorView {
    
    @ViewBuilder
    private var contentView: some View {
        if isExpanded {
            mainViewExpanded
        } else {
            mainViewCompact
        }
    }
    
    ///
    var mainViewExpanded: some View {
        ZStack {
            themeConfigurator
                .colorScheme(colorScheme)
                .surface
                .ignoresSafeArea()
            VStack(spacing: 20) {
                Spacer()
                
                imageView
                errorMessageView
                
                Spacer()
                
                if isButtonRetryEnabled {
                    buttons
                } else {
                    mainButton
                }
            }
            .padding()
        }
    }
    
    var mainViewCompact: some View {
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
    
    ///
    var imageView: some View {
        DomainImages.payError.image(
            themeConfigurator
                .colorScheme(colorScheme)
        )
        .resizable()
        .frame(width: 200, height: 200)
        .padding(.bottom, 16)
        .accessibilityIdentifier(tags.image)
        
    }
    
    ///
    var errorMessageView: some View {
        Text(errorMessage)
            .accessibilityIdentifier(tags.message)
            .foregroundColor(
                themeConfigurator
                    .colorScheme(colorScheme)
                    .onSurface
            )
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
        }
    }
    
    ///
    private var mainButton: some View {
        Button(action: {
            if isButtonRetryEnabled {
                onRetry()
            } else {
                onCancel()
            }
        }) {
            Text(isButtonRetryEnabled ?
                 Localization.rozetka_pay_common_button_retry.description :
                    cancelButtonTitle
            )
            .font(
                themeConfigurator
                    .typography
                    .labelLarge
            )
            .foregroundColor(
                themeConfigurator
                    .colorScheme(colorScheme)
                    .onPrimary
            )
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity
            )
        }
        .accessibilityIdentifier(tags.mainButton)
        .frame(height:
            themeConfigurator
            .sizes
            .buttonFrameHeight
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
    
    ///
    private var secondButton: some View {
        Button(action: {
            onCancel()
        }) {
            Text(cancelButtonTitle
            )
            .font(
                themeConfigurator
                    .typography
                    .labelLarge
            )
            .foregroundColor(
                themeConfigurator
                    .colorScheme(colorScheme)
                    .primary
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .accessibilityIdentifier(tags.secondButton)
        .frame(height:
                themeConfigurator
            .sizes
            .buttonFrameHeight
        )
        .background(.clear)
        .cornerRadius(
            themeConfigurator
                .sizes
                .buttonCornerRadius
        )
    }
}

//MARK: - Preview
#Preview {
    ErrorView(
        accessibilityNamespace: "test",
        themeConfigurator: RozetkaPayThemeConfigurator(mode: .system),
        errorMessage: "test \n test",
        onCancel: { print("Cancel tapped") },
        onRetry: { print("Retry tapped") }
    )
}
