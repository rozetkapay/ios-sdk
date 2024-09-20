//
//  AddNewCardView.swift
//
//
//  Created by Ruslan Kasian Dev on 20.08.2024.
//

import SwiftUI
import PassKit

public struct PayView: View {
   
    ///
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: PayViewModel
    
    public init(
        parameters: PaymentParameters,
        callback: @escaping (PaymentResult) -> Void
    ) {
        
        self._viewModel = StateObject(
            wrappedValue: PayViewModel(
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
                    applePayButton
                    CardInfoView(
                        viewParameters: viewModel.viewParameters,
                        themeConfigurator: viewModel.themeConfigurator,
                        isNeedToTokenizationCard: $viewModel.isNeedToTokenizationCard,
                        isShowNeedToTokenizationCard: viewModel.isAllowTokenization,
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
                    cardPayButton
                    footerView
                    LegalTextView()
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
    
    //MARK: - headerView
    private var headerView: some View {
        VStack(alignment: .leading) {
            HStack{
                Text(Localization.rozetka_pay_payment_title.description)
                    .font(.title)
                    .bold()
                    .padding(.bottom, 20)
                Spacer()
            }
        }
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
    
    //MARK: - Methods
    private var closeButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "xmark")
                .foregroundColor(.black)
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private var applePayButton: some View {
        ApplePayButton(
            action: viewModel.startApplePayPayment,
            paymentButtonStyle:
                viewModel.themeConfigurator.darkColorScheme.applePayButtonStyle
        )
        .frame(height: 50)
        .cornerRadius(viewModel.themeConfigurator.sizes.buttonCornerRadius)
        .padding(.top, 20)
        .clipShape(
            RoundedRectangle(cornerRadius: viewModel.themeConfigurator.sizes.buttonCornerRadius)
        )
    }
    
    private var cardPayButton: some View {
        Button(action: {
            viewModel.validateAll()
        }) {
            Text(Localization.rozetka_pay_payment_pay_button.description(with: [viewModel.amountWithCurrencyStr]))
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .font(.headline)
                .background(Color.green)
                .cornerRadius(viewModel.themeConfigurator.sizes.buttonCornerRadius)
        }
        .padding(.top, 20)
    }
    
}

#Preview {
    PayView(parameters: PaymentParameters(
        client: ClientAuthParameters(token: "test"),
        amountParameters: PaymentParameters.AmountParameters(
            amount: 100.00,
            currencyCode: "UAH"
        ),
        orderId: "test"
    ),
            callback: {
        _ in
    })
}
