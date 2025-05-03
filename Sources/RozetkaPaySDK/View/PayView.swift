//
//  AddNewCardView.swift
//
//
//  Created by Ruslan Kasian Dev on 20.08.2024.
//

import SwiftUI
import PassKit

public struct PayView: View {
   
    //MARK: - Properties
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel: PayViewModel
    
    //MARK: - Init
    public init(
        parameters: PaymentParameters,
        onResultCallback: @escaping PaymentResultCompletionHandler
    ) {
        self._viewModel = StateObject(
            wrappedValue: PayViewModel(
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
        .fullScreenCover(isPresented:  $viewModel.isThreeDSConfirmationPresented) {
            threeDSView
        }
        .customAlert(
            item: $viewModel.alertItem,
            themeConfigurator: viewModel.themeConfigurator
        )
    }
}

//MARK: UI
private extension PayView {
    
    var mainView: some View {
        VStack {
            headerView
            applePayButton
            cardInfoView
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
    ///
    var loadingView: some View {
        ZStack {
            viewModel
                .themeConfigurator
                .colorScheme(colorScheme)
                .surface.opacity(0.8)
                .ignoresSafeArea()
            LoadingView(
                tintColor: viewModel.themeConfigurator.colorScheme(colorScheme).primary,
                textFont: viewModel.themeConfigurator.typography.body,
                textColorDark: viewModel.themeConfigurator.darkColorScheme.onSurface,
                textColorWhite: viewModel.themeConfigurator.lightColorScheme.onSurface,
                backgroundColorDark: viewModel.themeConfigurator.darkColorScheme.surface,
                backgroundColorWhite: viewModel.themeConfigurator.lightColorScheme.surface
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
                viewModel.validateAll()
            }
        )
        .padding()
    }
    
    ///
    @ViewBuilder var threeDSView: some View {
        if let request = viewModel.threeDSModel {
            ThreeDSHandlerView(
                themeConfigurator: viewModel.themeConfigurator,
                request: request,
                isPresented: $viewModel.isThreeDSConfirmationPresented,
                onResultCallback: viewModel.handleThreeDSResult
            )
        }
    }
    ///
    var cardInfoView: some View {
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
            errorMessageEmail: $viewModel.errorMessageEmail
        )
        
    }
    
    ///
    private var closeButton: some View {
        Button(action: {
            viewModel.cancelled()
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
    
    private var applePayButton: some View {
        ApplePayButton(
            action: viewModel.startPayByApplePay,
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
        .padding(.bottom, viewModel.viewParameters.cardNameField.isShow ? 16 : 0)
        .clipShape(
            RoundedRectangle(
                cornerRadius:
                    viewModel
                    .themeConfigurator
                    .sizes
                    .buttonCornerRadius)
        )
    }
}


//MARK: Private Methods
private extension PayView {
    private func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}

#Preview {
    PayView(parameters: PaymentParameters(
        client: ClientAuthParameters(token: "test", widgetKey: "test"),
        viewParameters: PaymentViewParameters(
            cardNameField: .none,
            emailField: .required,
            cardholderNameField: .required
        ),
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
