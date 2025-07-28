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
//    @State private var isScrollEnabled: Bool = true
    @State private var contentHeight: CGFloat = .zero
    
    //MARK: - Inits
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
            contentView
                .background(
                    viewModel
                        .themeConfigurator
                        .colorScheme(colorScheme)
                        .surface
                )
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
    
    @ViewBuilder
    private var contentView: some View {
        if viewModel.isLoading {
            loadingView
        } else if viewModel.isError {
            errorView
        } else {
            mainView
        }
    }
    
    var mainView: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: viewModel.getVStackSpacing()) {
                    headerView

                    if viewModel.getIsAllowApplePay() {
                        applePayView
                    }

                    cardInfoView
                    cardPayButton
                    footerView
                }
                .padding()
            }
        }
        .background(
            viewModel
                .themeConfigurator
                .colorScheme(colorScheme)
                .surface
        )
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
            LoadingView (themeConfigurator: viewModel.themeConfigurator)
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
    var closeButton: some View {
        Button(action: {
            viewModel.cancelled()
            presentationMode.wrappedValue.dismiss()
        }) {
            DomainImages.xmark.image(
                viewModel
                    .themeConfigurator
                    .colorScheme(colorScheme)
            )
            .renderingMode(.template)
            .foregroundColor(
                viewModel
                    .themeConfigurator
                    .colorScheme(colorScheme)
                    .appBarIcon
            )
        }
    }
    
    var headerView: some View {
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
                    .padding(.bottom, 0)
                Spacer()
            }
        }
    }
    
    var footerView: some View {
        VStack(spacing: viewModel.getVStackSpacing()) {
            CardInfoFooterView(themeConfigurator: viewModel.themeConfigurator)
            LegalTextView(themeConfigurator: viewModel.themeConfigurator)
        }
        .padding(.top,
                 viewModel
                    .themeConfigurator
                    .sizes
                    .cardInfoLegalViewTopPadding
        )
    }
    
    var cardPayButton: some View {
        Button(action: {
            viewModel.startPayByCard()
        }) {
            Text(
                Localization.rozetka_pay_payment_pay_button.description(with: [
                    viewModel.getAmountWithCurrency()
                ])
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
    
    var applePayView: some View {
        VStack(alignment: .leading, spacing: viewModel.getVStackSpacing()) {
            applePayButton
            LabeledDivider(
                label: Localization.rozetka_pay_payment_devider_label_text.description,
                viewModel.themeConfigurator
            )
        }
    }
    
    var applePayButton: some View {
        ApplePayButton(
            action: viewModel.startPayByApplePay,
            paymentButtonStyle:
                viewModel
                .themeConfigurator
                .colorScheme(colorScheme)
                .applePayButtonStyle
        )
        .frame(
            height:
                viewModel
                .themeConfigurator
                .sizes
                .applePayButtonFrameHeight
        )
        .cornerRadius(
            viewModel
                .themeConfigurator
                .sizes
                .buttonCornerRadius
        )
        
        .clipShape(
            RoundedRectangle(
                cornerRadius:
                    viewModel
                    .themeConfigurator
                    .sizes
                    .buttonCornerRadius
            )
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
                        cardNameField: .optional,
                        emailField: .optional,
                        cardholderNameField: .optional
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
