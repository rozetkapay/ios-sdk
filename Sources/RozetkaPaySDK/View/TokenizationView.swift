//
//  TokenizationView.swift
//
//
//  Created by Ruslan Kasian Dev on 20.08.2024.
//
import SwiftUI

public struct TokenizationView: View {
    
    private enum Constants {
        static let textFieldCornerRadius: CGFloat = 16
        static let textFieldFrameHeight: CGFloat = 22
        static let buttonCornerRadius: CGFloat = 16
    }
    
    //MARK: - Properties
    private let parameters: TokenizationParameters
    
    ///
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: TokenizationViewModel
    
    //MARK: - Init
    public init(
        parameters: TokenizationParameters,
        callback: @escaping (TokenizationResult) -> Void
    ) {
        self.parameters = parameters
        self._viewModel = StateObject(
            wrappedValue: TokenizationViewModel(
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
                    formView
                    saveButton
                    footerView
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
    
    private var formView: some View {
        Group {
            if viewModel.isShowCardName {
                VStack(spacing: 16) {
                    cardNameView
                }
            }
            HStack{
                Text(Localization.rozetka_pay_form_card_info_title.description)
                    .font(.headline)
                    .padding(.top, 20)
                Spacer()
            }
            VStack(spacing: 16) {
                cardDetailsView
                if viewModel.isShowCardholderName {
                    cardHolderNameView
                }
                
                if viewModel.isShowEmail {
                    emailView
                }
            }
            
        }
    }
    
    private var cardNameView: some View {
        VStack(spacing: 0) {
            VStack(spacing: 2){
                InputTextFieldRepresentable(
                    Localization.rozetka_pay_form_optional_card_name.description,
                    text: $viewModel.cardName,
                    contentType: .name,
                    keyboardType: .default
                )
                .frame(height: Constants.textFieldFrameHeight)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(Constants.textFieldCornerRadius)
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
    
    private var emailView: some View {
        VStack(spacing: 0) {
            VStack(spacing: 2){
                InputTextFieldRepresentable(
                    Localization.rozetka_pay_form_email.description,
                    text: $viewModel.email,
                    textColor: viewModel.errorMessagEmail.isNilOrEmpty ? .black : .red,
                    contentType: .emailAddress,
                    keyboardType: .emailAddress,
                    validators: ValidatorsComposer(validators: [
                        EmailValidator()
                    ]),
                    validationTextFieldResult: { result in
                        switch result {
                        case .valid:
                            viewModel.errorMessagEmail = nil
                        case let .error(message):
                            viewModel.errorMessagEmail = message
                        }
                    }
                )
                .frame(height: Constants.textFieldFrameHeight)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(Constants.textFieldCornerRadius)
                
                if let errorMessage = viewModel.errorMessagEmail.isNilOrEmptyValue {
                    
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
        }
    }
    
    private var saveButton: some View {
        Button(action: {
            viewModel.validateAll()
        }) {
            Text(Localization.rozetka_pay_form_save_card.description)
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(Color.green)
                .cornerRadius(Constants.buttonCornerRadius)
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
        
        
        
        
        
//        card: CardData(
//            cardName: nil,
//            cardNumber: "5168 7450 2164 9378",
//            expiryDate: CardExpirationDate(
//                month: 11,
//                year: 24
//            ),
//            cvv: "123",
//            cardholderName: nil,
//            email: nil
//        )
//    )
}
