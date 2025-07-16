//
//  TokenizationView.swift
//
//
//  Created by Ruslan Kasian Dev on 20.08.2024.
//
import SwiftUI

public struct TokenizationView: View {
    
    //MARK: - Properties
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel: TokenizationViewModel
    
    //MARK: - Init
    public init(
        parameters: TokenizationParameters,
        onResultCallback: @escaping TokenizationResultCompletionHandler
    ) {
        self._viewModel = StateObject(
            wrappedValue: TokenizationViewModel(
                parameters: parameters,
                onResultCallback: onResultCallback
            )
        )
    }
    
    //MARK: - Body
    public var body: some View {
        NavigationView {
            if viewModel.isLoading {
                loadingView
            }else if viewModel.isError {
                errorView
            }else {
                mainView
            }
        }
    }
}

//MARK: UI
private extension TokenizationView {
    
    ///
    var headerView: some View {
        VStack(alignment: .leading) {
            HStack{
                Text(Localization.rozetka_pay_tokenization_title.description)
                    .font(
                        viewModel
                            .themeConfigurator
                            .typography
                            .title
                    )
                    .bold()
                    .foregroundColor(
                        viewModel
                            .themeConfigurator
                            .colorScheme(colorScheme)
                            .title
                        
                    )
                    .padding(.bottom, 20)
                Spacer()
            }
        }
    }
    
    var mainView: some View {
        VStack {
            headerView
            cardInfoView
            mainButton
            footerView
            Spacer()
        }
        .padding()
        .navigationBarItems(leading: closeButton)
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    ///
    var loadingView: some View {
        ZStack {
            viewModel
                .themeConfigurator
                .colorScheme(colorScheme)
                .surface
                .opacity(0.8)
                .ignoresSafeArea()
            LoadingView(
                tintColor:
                    viewModel
                    .themeConfigurator
                    .colorScheme(colorScheme)
                    .primary
                ,
                textFont:
                    viewModel
                    .themeConfigurator
                    .typography
                    .body
                ,
                textColorDark:
                    viewModel
                    .themeConfigurator
                    .darkColorScheme
                    .onSurface
                ,
                textColorWhite:
                    viewModel
                    .themeConfigurator
                    .lightColorScheme
                    .onSurface
                ,
                backgroundColorDark:
                    viewModel
                    .themeConfigurator
                    .darkColorScheme
                    .surface
                ,
                backgroundColorWhite:
                    viewModel
                    .themeConfigurator
                    .lightColorScheme
                    .surface
            )
        }
    }
    ///
    var errorView: some View {
        ErrorView(
            themeConfigurator: viewModel.themeConfigurator,
            errorMessage: viewModel.errorMessage,
            onCancel: {
                viewModel.cancelled()
            },
            onRetry: {
                viewModel.retryLoading()
            }
        )
        .padding()
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
    var closeButton: some View {
        Button(action: {
            viewModel.cancelled()
            presentationMode.wrappedValue.dismiss()
        }) {
            DomainImages.xmark.image()
                .foregroundColor(
                    viewModel
                        .themeConfigurator
                        .colorScheme(colorScheme)
                        .appBarIcon
                )
        }
    }
    ///
    var footerView: some View {
        CardInfoFooterView()
            .padding(.top, 20)
    }
    
    ///
    private var mainButton: some View {
        Button(action: {
            viewModel.startLoading()
        }) {
            Text(
                Localization.rozetka_pay_form_save_card.description
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
private extension TokenizationView {
    
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
    TokenizationView(
        parameters: TokenizationParameters(
            client: ClientWidgetParameters(widgetKey: "test")
        ),
        onResultCallback: {
            _ in
        })
}
