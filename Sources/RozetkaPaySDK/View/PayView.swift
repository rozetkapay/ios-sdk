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
        paymentParameters: PaymentParameters,
        onResultCallback: @escaping PaymentResultCompletionHandler
    ) {
        self._viewModel = StateObject(
            wrappedValue: PayViewModel(
                parameters: paymentParameters,
                onResultCallback: onResultCallback
            )
        )
    }
    
    public init(
        batchPaymentParameters: BatchPaymentParameters,
        onResultCallback: @escaping BatchPaymentResultCompletionHandler
    ) {
        self._viewModel = StateObject(
            wrappedValue: PayViewModel(
                parameters: batchPaymentParameters,
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
                viewModel.retryLoading()
            },
            isButtonRetryEnabled: viewModel.getIsRetryEnabled()
        )
        .padding()
    }
    
    ///
    @ViewBuilder var threeDSView: some View {
        if let request = viewModel.getThreeDSModel() {
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
            DomainImages.xmark.image()
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
        CardInfoFooterView()
        .padding(.top, 20)
    }
    
    private var cardPayButton: some View {
        Button(action: {
            viewModel.startPayByCard()
        }) {
            Text(Localization.rozetka_pay_payment_pay_button.description(with: [
                viewModel.getAmountWithCurrency()
            ]))
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
    PayView(
        paymentParameters: PaymentParameters(
        client: ClientAuthParameters(token: "test", widgetKey: "test"),
        paymentType: .regular(
            RegularPayment(
                viewParameters: PaymentViewParameters(
                    cardNameField: .none,
                    emailField: .required,
                    cardholderNameField: .required
                ),
                isAllowTokenization: true,
                applePayConfig: nil
        )),
        amountParameters: AmountParameters(
            amount: 10000,
            currencyCode: "UAH"
        ),
        externalId: "test"
    ),
    onResultCallback: {
        _ in
    })
}
