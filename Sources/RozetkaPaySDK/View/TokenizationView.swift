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
        callback: @escaping (TokenizationResult) -> Void
    ) {
        self._viewModel = StateObject(
            wrappedValue: TokenizationViewModel(
                parameters: parameters,
                callback: callback
            )
        )
    }
    
    public var body: some View {
        NavigationView {
            if viewModel.isLoading {
                ZStack {
                    Color.white
                        .ignoresSafeArea()
                    LoadingView()
                }
            }else if viewModel.isError {
                ErrorView(
                    errorMessage: viewModel.errorMessage,
                    onCancel: {
                        viewModel.cancelled()
                    },
                    onRetry: {
                        viewModel.validateAll()
                    }
                )
                .padding()
            }else {
                VStack {
                    headerView
                    CardInfoView(
                        viewParameters: viewModel.viewParameters,
                        themeConfigurator: viewModel.themeConfigurator,
                        isNeedToTokenizationCard: $viewModel.isNeedToTokenizationCard,
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
                        errorMessagEmail: $viewModel.errorMessagEmail
                    )
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
        }
    }
    
    private var headerView: some View {
        VStack(alignment: .leading) {
            HStack{
                Text(Localization.rozetka_pay_tokenization_title.description)
                    .font(.title)
                    .bold()
                    .padding(.bottom, 20)
                Spacer()
            }
        }
    }
    
    private var mainButton: some View {
        Button(action: {
            viewModel.validateAll()
        }) {
            Text(Localization.rozetka_pay_form_save_card.description)
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(Color.green)
                .cornerRadius(viewModel.themeConfigurator.sizes.buttonCornerRadius)
        }
        .padding(.top, 20)
    }
    
    private var footerView: some View {
        HStack {
            Spacer()
            Image("rozetka_pay_legal_visa", bundle: .module)
            Image("rozetka_pay_legal_pcidss", bundle: .module)
            Image("rozetka_pay_legal_mastercard", bundle: .module)
            Spacer()
        }
        .padding(.top, 20)
    }
    
    private var closeButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "xmark")
                .foregroundColor(.primary)
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    TokenizationView(
        parameters: TokenizationParameters(
            client: ClientWidgetParameters(widgetKey: "test")
        ),
        callback: {
        _ in
    })
}
