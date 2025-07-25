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
        mainView
    }
}

//MARK: UI
private extension TokenizationFormView {
    
    var mainView: some View {
        VStack(spacing: 0) {
            cardInfoView
               
            if !isFooterEmpty {
                cardFormFooterEmbeddedContent()
                    .padding(.top, viewModel.getVStackSpacing())
            }
            mainButton
            if viewModel.viewParameters.isVisibleCardInfoLegalView {
                legalView
                    .padding(.top, viewModel.getVStackSpacing())
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
            viewParameters: viewModel.viewParameters,
            themeConfigurator: viewModel.themeConfigurator,
            cardNumber: $viewModel.cardNumber,
            cvv: $viewModel.cvv,
            expiryDate: $viewModel.expiryDate,
            cardName: $viewModel.cardName,
            cardholderName: $viewModel.cardholderName,
            email: $viewModel.email,
            errorMessageCardNumber: $viewModel.errorMessageCardNumber,
            errorMessageCvv: $viewModel.errorMessageCvv,
            errorMessageExpiryDate: $viewModel.errorMessageExpiryDate,
            errorMessageCardName: $viewModel.errorMessageCardName,
            errorMessageCardholderName: $viewModel.errorMessageCardholderName,
            errorMessageEmail: $viewModel.errorMessageEmail
        )
    }
    ///
    var legalView: some View {
        CardInfoFooterView(themeConfigurator: viewModel.themeConfigurator)
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
            .bold()
            .foregroundColor(
                viewModel
                    .themeConfigurator
                    .colorScheme(colorScheme)
                    .onPrimary
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
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
        .padding(.top, viewModel.themeConfigurator.sizes.mainButtonTopPadding)
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
            themeConfigurator: RozetkaPayThemeConfigurator(mode: .dark)
        ),
        onResultCallback: {
            _ in
        }, stateUICallback: {
            _ in
        }
    )
}
