//
//  TokenizationFormView.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 10.07.2025.
//
import SwiftUI

public struct TokenizationFormView<Content: View>: View {
    
    //MARK: - Properties
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel: TokenizationFormViewModel
    private let cardFormFooterEmbeddedContent: (() -> Content)
    
    private var tags: AccessibilityTag.TokenizationForm {
        AccessibilityTag.TokenizationForm()
    }
    
    private var isFooterEmpty: Bool {
        return Content.self == EmptyView.self
    }
    
    //MARK: - Init
    public init(
        parameters: TokenizationFormParameters,
        onResultCallback: @escaping TokenizationFormResultCompletionHandler,
        stateUICallback: @escaping TokenizationFormUIStateCompletionHandler,
        @ViewBuilder cardFormFooterEmbeddedContent: @escaping () -> Content = { EmptyView() }
    ) {
        self._viewModel = StateObject(
            wrappedValue: TokenizationFormViewModel(
                parameters: parameters,
                onResultCallback: onResultCallback,
                stateUICallback: stateUICallback
            )
        )
        self.cardFormFooterEmbeddedContent = cardFormFooterEmbeddedContent
    }
    
    //MARK: - Body
    public var body: some View {
        contentView
    }
}

//MARK: UI
private extension TokenizationFormView {
    
    @ViewBuilder
    private var contentView: some View {
        ZStack {
            mainView
            if viewModel.isLoading {
                loadingView
            }
            if viewModel.isError {
                errorView
            }
        }
    }
    
    var loadingView: some View {
        ZStack {
            viewModel
                .themeConfigurator
                .colorScheme(colorScheme)
                .surface
                .opacity(0.8)
                .ignoresSafeArea()
            LoadingView (
                accessibilityNamespace: tags.base,
                themeConfigurator: viewModel.themeConfigurator,
                isExpanded: true
            )
                .accessibilityIdentifier(tags.loadingView)
        }
        .padding()
    }
    ///
    var errorView: some View {
        ErrorView(
            accessibilityNamespace: tags.base,
            themeConfigurator: viewModel.themeConfigurator,
            errorMessage: viewModel.errorMessage,
            onCancel: {
                viewModel.cancelled()
            },
            onRetry: {
                viewModel.retryLoading()
            },
            isExpanded: true
        )
        .accessibilityIdentifier(tags.errorView)
        .padding()
    }
    
    var mainView: some View {
        VStack(spacing: 0) {
            cardInfoView
            
            if !isFooterEmpty {
                cardFormFooterEmbeddedContent()
                    .accessibilityIdentifier(tags.cardFormFooterEmbeddedContent)
                    .padding(
                        .top,
                        viewModel
                            .themeConfigurator
                            .sizes
                            .cardFormFooterEmbeddedContentTopPadding
                    )
            }
            mainButton
            if viewModel.viewParameters.isVisibleCardInfoLegalView {
                legalView
            }
            Spacer()
        }
        .background(.clear)
        .padding()
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    ///
    var cardInfoView: some View {
        CardInfoView(
            accessibilityNamespace: tags.base,
            viewParameters: viewModel.viewParameters,
            themeConfigurator: viewModel.themeConfigurator,
            cardNumber: $viewModel.cardNumber,
            cvv: $viewModel.cvv,
            expiryDate: $viewModel.expiryDate,
            cardName: $viewModel.cardName,
            cardholderName: $viewModel.cardholderName,
            email: $viewModel.email,
            cardNumberStatus: $viewModel.cardNumberStatus,
            cvvStatus: $viewModel.cvvStatus,
            expiryDateStatus: $viewModel.expiryDateStatus,
            cardNameStatus: $viewModel.cardNameStatus,
            cardholderNameStatus: $viewModel.cardholderNameStatus,
            emailStatus: $viewModel.emailStatus,
            didPerformInitialValidation: $viewModel.didPerformInitialValidation
        )
        .accessibilityIdentifier(tags.cardInfoView)
    }
    ///
    var legalView: some View {
        CardInfoFooterView(themeConfigurator: viewModel.themeConfigurator)
            .accessibilityIdentifier(tags.cardInfoFooter)
            .padding(.top,
                     viewModel
                .themeConfigurator
                .sizes
                .cardInfoLegalViewTopPadding
            )
    }
    
    ///
    private var mainButton: some View {
        Button(action: {
            viewModel.startLoading()
        }) {
            Text(
                viewModel
                    .viewParameters
                    .stringResources
                    .buttonTitle
            )
            .font(
                viewModel
                    .themeConfigurator
                    .typography
                    .labelLarge
            )
            .foregroundColor(
                viewModel
                    .themeConfigurator
                    .colorScheme(colorScheme)
                    .onPrimary
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .accessibilityIdentifier(tags.mainButton)
        .frame(height:
            viewModel
                .themeConfigurator
                .sizes
                .buttonFrameHeight
        )
        .background(
            viewModel
                .themeConfigurator
                .colorScheme(colorScheme)
                .primary
        )
        .cornerRadius(
            viewModel
                .themeConfigurator
                .sizes
                .buttonCornerRadius
        )
        .padding(.top,
                 viewModel
            .themeConfigurator
            .sizes
            .mainButtonTopPadding
        )
    }
}


//MARK: Private Methods
private extension TokenizationFormView {
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}

//MARK: Preview
#Preview {
    TokenizationFormView(
        
        parameters: TokenizationFormParameters(
            client: ClientWidgetParameters(widgetKey: "test"),
            themeConfigurator: RozetkaPayThemeConfigurator(mode: .light)
        ),
        onResultCallback: {
            _ in
        }, stateUICallback: {
            _ in
        }
    )
}
