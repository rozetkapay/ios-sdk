//
//  TokenizationContentView.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 10.07.2025.
//
import SwiftUI

public struct TokenizationContentView<Content: View>: View {
    
    //MARK: - Properties
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel: TokenizationContentViewModel
    private let cardFormFooterEmbeddedContent: (() -> Content)
    
    //MARK: - Init
    public init(
        parameters: TokenizationContentParameters,
        onResultCallback: @escaping TokenizationContentResultCompletionHandler,
        stateUICallback: @escaping TokenizationContentUIStateCompletionHandler,
        @ViewBuilder cardFormFooterEmbeddedContent: @escaping () -> Content = { EmptyView() }
    ) {
        self._viewModel = StateObject(
            wrappedValue: TokenizationContentViewModel(
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
private extension TokenizationContentView {
    
    var mainView: some View {
        VStack {
            cardInfoView
            cardFormFooterEmbeddedContent()
            mainButton
            if viewModel.viewParameters.isVisibleCardInfoLegalView {
                legalView
            }
            Spacer()
        }
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
        CardInfoFooterView()
        .padding(.top, 20)
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
        .padding(.top, 20)
    }
}


//MARK: Private Methods
private extension TokenizationContentView {

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
    TokenizationContentView(
        parameters: TokenizationContentParameters(
            client: ClientWidgetParameters(widgetKey: "test")
        ),
        onResultCallback: {
        _ in
        }, stateUICallback: {
            _ in
        }
    )
}
