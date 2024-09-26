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
    @Environment(\.colorScheme) var colorScheme
    
    public init(
        parameters: PaymentParameters,
        onResultCallback: @escaping (PaymentResult) -> Void
    ) {
        
        self._viewModel = StateObject(
            wrappedValue: PayViewModel(
                parameters: parameters,
                onResultCallback: onResultCallback
            )
        )
    }
    
    public var body: some View {
        NavigationView {
            if viewModel.isLoading {
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
            }else if viewModel.isError {
                ErrorView(
                    themeConfigurator: viewModel.themeConfigurator, 
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
                .foregroundColor(
                    viewModel
                        .themeConfigurator
                        .colorScheme(colorScheme)
                        .appBarIcon
                )
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private var applePayButton: some View {
        ApplePayButton(
            action: viewModel.startApplePayPayment,
            paymentButtonStyle:
                viewModel
                .themeConfigurator
                .colorScheme(colorScheme)
                .applePayButtonStyle
        )
        .frame(height: 50)
        .cornerRadius(
            viewModel
                .themeConfigurator
                .sizes
                .buttonCornerRadius)
        .padding(.top, 20)
        .clipShape(
            RoundedRectangle(
                cornerRadius:
                    viewModel
                    .themeConfigurator
                    .sizes
                    .buttonCornerRadius)
        )
    }
    
    private var cardPayButton: some View {
        Button(action: {
            viewModel.validateAll()
        }) {
            Text(Localization.rozetka_pay_payment_pay_button.description(with: [viewModel.amountWithCurrencyStr]))
                .font(
                    viewModel
                        .themeConfigurator
                        .typography
                        .labelLarge
                )
                .bold()
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(
                    viewModel
                        .themeConfigurator
                        .colorScheme(colorScheme)
                        .onPrimary
                    
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
    onResultCallback: {
        _ in
    })
}
