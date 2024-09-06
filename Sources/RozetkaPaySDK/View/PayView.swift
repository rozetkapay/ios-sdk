//
//  AddNewCardView.swift
//
//
//  Created by Ruslan Kasian Dev on 20.08.2024.
//

import SwiftUI
import PassKit

public struct PayView: View {
    let applePaymentHandler: ApplePaymentHandler?
    
    private enum Constants {
        static let textFieldCornerRadius: CGFloat = 16
        static let textFieldFrameHeight: CGFloat = 22
        static let buttonCornerRadius: CGFloat = 16
    }
    
    ///
    private let parameters: PaymentParameters
    ///
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: PayViewModel
    
    public init(
        parameters: PaymentParameters,
        callback: @escaping (PaymentResult) -> Void
    ) {
        self.parameters = parameters
        self.applePaymentHandler = ApplePaymentHandler(config: parameters.applePayConfig)
        
        self._viewModel = StateObject(
            wrappedValue: PayViewModel(
                parameters: parameters,
                callback: callback
            )
        )
    }
    
    public var body: some View {
        NavigationView {
            if viewModel.isLoaded {
                VStack {
                    headerView
                    applePayButton
                    formView
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
                
            } else {
                ZStack {
                    Color.white
                        .ignoresSafeArea()
                    LoadingView()
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
    
    //MARK: - formView
    private var formView: some View {
        Group {
            HStack{
                Text(Localization.rozetka_pay_form_card_info_title.description)
                    .font(.headline)
                    .padding(.top, 20)
                Spacer()
            }
            VStack(spacing: 16) {
                cardDetailsView
                
            }
            
        }
    }
    
    private var cardHolderNameView: some View {
        VStack(spacing: 0) {
            VStack(spacing: 2){
                InputTextFieldRepresentable(
                    Localization.rozetka_pay_form_cardholder_name.description,
                    text: $viewModel.cardholderName,
                    textColor: viewModel.errorMessageCardholderName.isNilOrEmpty ? .black : .red,
                    contentType: .name,
                    keyboardType: .default,
                    validators: ValidatorsComposer(validators: [
                        CardholderNameValidator()
                    ]),
                    validationTextFieldResult: { result in
                        switch result {
                        case .valid:
                            viewModel.errorMessageCardholderName = nil
                        case let .error(message):
                            viewModel.errorMessageCardholderName = message
                        }
                    }
                )
                .frame(height: Constants.textFieldFrameHeight)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(Constants.textFieldCornerRadius)
                
                if let errorMessage = viewModel.errorMessageCardholderName.isNilOrEmptyValue {
                    
                    HStack{
                        Text(errorMessage)
                            .font(.subheadline)
                            .foregroundColor(.red)
                            .padding()
                        Spacer()
                    }
                }
            }
        }
    }
    
    private var cardDetailsView: some View {
        VStack(spacing: 0) {
            VStack(spacing: 2) {
                HStack {
                    InputTextFieldRepresentable(
                        Localization.rozetka_pay_form_card_number.description,
                        text: $viewModel.cardNumber,
                        textColor: viewModel.errorMessageCardNumber.isNilOrEmpty ? .black : .red,
                        contentType: .dateTime,
                        keyboardType: .numberPad,
                        maxLength: CardNumberValidator.MAX_CARD_NUMBER_LENGTH,
                        validators: ValidatorsComposer(validators: [
                            CardNumberValidator()
                        ]),
                        validationTextFieldResult: { result in
                            switch result {
                            case .valid:
                                viewModel.errorMessageCardNumber = nil
                            case let .error(message):
                                viewModel.errorMessageCardNumber = message
                            }
                        },
                        textMasking: CardNumberMask()
                    )
                    .frame(height: Constants.textFieldFrameHeight)
                    .padding()
                    .keyboardType(.numberPad)
                    .background(Color(.systemGray6))
                    .clipShape(
                        RoundedCorner(
                            radius: Constants.textFieldCornerRadius,
                            corners: [.topLeft, .topRight]
                        )
                    )
                    Image(
                        viewModel.paymentSystemLogoName,
                        bundle: .module
                    )
                    .resizable()
                    .frame(width: 36, height: 22)
                    .padding(.trailing)
                }
                .background(Color(UIColor.systemGray6))
                .clipShape(
                    RoundedCorner(
                        radius: Constants.textFieldCornerRadius,
                        corners: [.topLeft, .topRight]
                    )
                )
                ///
                HStack(spacing: 2) {
                    InputTextFieldRepresentable(
                        Localization.rozetka_pay_form_exp_date.description,
                        text: $viewModel.expiryDate,
                        textColor: viewModel.errorMessageExpiryDate.isNilOrEmpty ? .black : .red,
                        contentType: .dateTime,
                        keyboardType: .numberPad,
                        maxLength: CardExpirationDateValidator.MAX_CREDIT_CARD_EXPIRATION_DATE_LENGTH,
                        validators: ValidatorsComposer(validators: [
                            CardExpirationDateValidator(
                                expirationValidationRule: RozetkaPaySdkValidationRules().cardExpirationDateValidationRule
                            )
                        ]),
                        validationTextFieldResult: { result in
                            switch result {
                            case .valid:
                                viewModel.errorMessageExpiryDate = nil
                            case let .error(message):
                                viewModel.errorMessageExpiryDate = message
                            }
                        },
                        textMasking: ExpirationDateMask()
                    )
                    .frame(height: Constants.textFieldFrameHeight)
                    .padding()
                    .keyboardType(.numberPad)
                    .background(Color(.systemGray6))
                    .clipShape(
                        RoundedCorner(
                            radius: Constants.textFieldCornerRadius,
                            corners: [.bottomLeft]
                        )
                    )
                    
                    InputTextFieldRepresentable(
                        Localization.rozetka_pay_form_cvv.description,
                        text: $viewModel.cvv,
                        textColor: viewModel.errorMessageCvv.isNilOrEmpty ? .black : .red,
                        isSecure: true,
                        contentType: .password,
                        keyboardType: .numberPad,
                        maxLength: CardCVVValidator.MAX_CREDIT_CARD_CVV_LENGTH,
                        validators: ValidatorsComposer(validators: [
                            CardCVVValidator()
                        ]),
                        validationTextFieldResult: { result in
                            switch result {
                            case .valid:
                                viewModel.errorMessageCvv = nil
                            case let .error(message):
                                viewModel.errorMessageCvv = message
                            }
                        }
                    )
                    .frame(height: Constants.textFieldFrameHeight)
                    .padding()
                    .keyboardType(.numberPad)
                    .background(Color(.systemGray6))
                    .clipShape(
                        RoundedCorner(
                            radius: Constants.textFieldCornerRadius,
                            corners: [.bottomRight]
                        )
                    )
                }
            }
            .background(Color(.systemGray5))
            .cornerRadius(Constants.textFieldCornerRadius)
            
            if let errorMessage = viewModel.errorMessageExpiryDate.isNilOrEmptyValue ??
                viewModel.errorMessageCardNumber.isNilOrEmptyValue ??
                viewModel.errorMessageCvv.isNilOrEmptyValue {
                
                HStack{
                    Text(errorMessage)
                        .font(.subheadline)
                        .foregroundColor(.red)
                        .padding()
                    Spacer()
                }
            }
            
            HStack{
                checkBoxView
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
    

    //MARK: - checkBox
    private var checkBoxView: some View {
        HStack {
            Toggle("", isOn: $viewModel.isNeedToTokenizationCard)
                .toggleStyle(CheckBoxStyle())
                .labelsHidden()
            
            Text(Localization.rozetka_pay_form_save_card.description)
                .font(.subheadline)
                .foregroundColor(.black)
        }
        .padding()
    }
    
    struct CheckBoxStyle: ToggleStyle {
        func makeBody(configuration: Configuration) -> some View {
            return Button(action: {
                configuration.isOn.toggle()
            }) {
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(configuration.isOn ? .black : .gray)
            }
        }
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
            action: startApplePayPayment,
            paymentButtonStyle: viewModel.themeConfigurator.darkColorScheme.applePayButtonStyle
        )
        .frame(height: 50)
        .cornerRadius(Constants.buttonCornerRadius)
        .padding(.top, 20)
        .clipShape(
            RoundedRectangle(cornerRadius: Constants.buttonCornerRadius)
        )
    }
    
    func startApplePayPayment() {
        self.applePaymentHandler?.startPayment { (success) in
            if success {
                print("Success")
            } else {
                print("Failed")
            }
        }
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
                .cornerRadius(Constants.buttonCornerRadius)
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
