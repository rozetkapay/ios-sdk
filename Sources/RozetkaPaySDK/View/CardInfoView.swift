//
//  CardInfoView.swift
//
//
//  Created by Ruslan Kasian Dev on 13.09.2024.
//

import SwiftUI

public struct CardInfoView: View {
    
    //MARK: - UI Properties
    ///
    @Binding var cardNumber: String?
    @Binding var cvv: String?
    @Binding var expiryDate: String?
    ///
    @Binding var cardName: String?
    @Binding var cardholderName: String?
    @Binding var email: String?
    ///
    @Binding var errorMessageCardNumber: String?
    @Binding var errorMessageCvv: String?
    @Binding var errorMessageExpiryDate: String?
    
    @Binding var errorMessageCardName: String?
    @Binding var errorMessageCardholderName: String?
    @Binding var errorMessagEmail: String?
    
    @Binding var isNeedToTokenizationCard: Bool
    
    //MARK: - Properties
    private let provideCardPaymentSystemUseCase: ProvideCardPaymentSystemUseCase
    private let themeConfigurator: RozetkaPayThemeConfigurator
    
    private var isShowCardName: Bool
    private var isShowCardholderName: Bool
    private var isShowEmail: Bool
    private var isShowNeedToTokenizationCard: Bool
    
    @State var detectedPaymentSystem: PaymentSystem?
    
    @Environment(\.colorScheme) var colorScheme
    
    private var paymentSystemLogoName: String {
        detectedPaymentSystem?.logoName ?? PaymentSystem.defaultLogoName
    }
    
    //MARK: - Init
    public init(
        viewParameters: ViewParametersProtocol,
        themeConfigurator: RozetkaPayThemeConfigurator,
        provideCardPaymentSystemUseCase: ProvideCardPaymentSystemUseCase? = nil,
        
        isNeedToTokenizationCard: Binding<Bool> = .constant(false),
        isShowNeedToTokenizationCard: Bool = false,
        ///
        cardNumber: Binding<String?>,
        cvv: Binding<String?>,
        expiryDate: Binding<String?>,
        cardName: Binding<String?>,
        cardholderName: Binding<String?>,
        email: Binding<String?>,
        
        ///
        errorMessageCardNumber: Binding<String?>,
        errorMessageCvv: Binding<String?>,
        errorMessageExpiryDate: Binding<String?>,
        errorMessageCardName: Binding<String?>,
        errorMessageCardholderName: Binding<String?>,
        errorMessagEmail: Binding<String?>
    ) {
        self.themeConfigurator = themeConfigurator
        self.provideCardPaymentSystemUseCase = provideCardPaymentSystemUseCase ?? ProvideCardPaymentSystemUseCase()
        self.isShowCardName = viewParameters.cardNameField.isShow
        self.isShowCardholderName = viewParameters.cardholderNameField.isShow
        self.isShowEmail = viewParameters.emailField.isShow
        self.isShowNeedToTokenizationCard = isShowNeedToTokenizationCard
        
        self._cardNumber = cardNumber
        self._cvv = cvv
        self._expiryDate = expiryDate
        self._cardName = cardName
        self._cardholderName = cardholderName
        self._email = email
        self._isNeedToTokenizationCard = isNeedToTokenizationCard
        
        self._errorMessageCardNumber = errorMessageCardNumber
        self._errorMessageCvv = errorMessageCvv
        self._errorMessageExpiryDate = errorMessageExpiryDate
        self._errorMessageCardName = errorMessageCardName
        self._errorMessageCardholderName = errorMessageCardholderName
        self._errorMessagEmail = errorMessagEmail
        
        self._detectedPaymentSystem = State(initialValue: self.detectPaymentSystem(cardNumber.wrappedValue))
    }
    
    @discardableResult
    private func detectPaymentSystem(_ value: String?) -> PaymentSystem? {
        return provideCardPaymentSystemUseCase.invoke(cardNumberPrefix: value)
    }
    
    public var body: some View {
        Group {
            if isShowCardName {
                VStack(spacing: 16) {
                    cardNameView
                }
            }
            HStack{
                Text(Localization.rozetka_pay_form_card_info_title.description)
                    .font(
                        themeConfigurator
                            .typography
                            .subtitle
                    )
                    .bold()
                    .foregroundColor(
                        themeConfigurator
                            .colorScheme(colorScheme)
                            .subtitle
                    )
                    .padding(.top, 20)
                Spacer()
            }
            VStack(spacing: 16) {
                cardDetailsView
                
                if isShowCardholderName {
                    cardHolderNameView
                }
                
                if isShowNeedToTokenizationCard{
                    HStack{
                        checkBoxView
                        Spacer()
                    }
                }
                
                if isShowEmail {
                    emailView
                }
                
            }
            
        }
        .onChange(of: cardNumber) { newValue in
            self.detectedPaymentSystem = self.detectPaymentSystem(newValue)
        }
    }
    
    private var cardNameView: some View {
        VStack(spacing: 0) {
            VStack(spacing: 2){
                InputTextFieldRepresentable(
                    placeholder: Localization.rozetka_pay_form_optional_card_name.description,
                    placeholderFont: themeConfigurator
                        .typography
                        .inputUI,
                    placeholderColor: themeConfigurator
                        .colorScheme(colorScheme)
                        .placeholder
                        .toUIColor(),
                    text: $cardName,
                    textColor: errorMessageCardName.isNilOrEmpty ?
                    themeConfigurator
                        .colorScheme(colorScheme)
                        .onComponent
                        .toUIColor()
                    :
                        themeConfigurator
                        .colorScheme(
                            colorScheme
                        )
                        .error
                        .toUIColor(),
                    contentType: .name,
                    keyboardType: .default
                )
                .frame(
                    height: themeConfigurator.sizes.textFieldFrameHeight
                )
                .padding()
                .background(
                    themeConfigurator
                        .colorScheme(colorScheme)
                        .componentSurface
                )
                .cornerRadius(
                    themeConfigurator
                        .sizes
                        .textFieldCornerRadius
                )
            }
        }
    }
    
    private var cardHolderNameView: some View {
        VStack(spacing: 0) {
            VStack(spacing: 2){
                InputTextFieldRepresentable(
                    placeholder: Localization.rozetka_pay_form_cardholder_name.description,
                    placeholderFont: themeConfigurator
                        .typography
                        .inputUI,
                    placeholderColor: themeConfigurator
                        .colorScheme(colorScheme)
                        .placeholder
                        .toUIColor(),
                    text: $cardholderName,
                    textColor: errorMessageCardholderName.isNilOrEmpty ?
                    themeConfigurator
                        .colorScheme(colorScheme)
                        .onComponent
                        .toUIColor()
                    :
                        themeConfigurator
                        .colorScheme(
                            colorScheme
                        )
                        .error
                        .toUIColor(),
                    contentType: .name,
                    keyboardType: .default,
                    validators: ValidatorsComposer(validators: [
                        CardholderNameValidator()
                    ]),
                    validationTextFieldResult: { result in
                        switch result {
                        case .valid:
                            errorMessageCardholderName = nil
                        case let .error(message):
                            errorMessageCardholderName = message
                        }
                    }
                )
                .frame(height: themeConfigurator.sizes.textFieldFrameHeight)
                .padding()
                .background(
                    themeConfigurator
                        .colorScheme(colorScheme)
                        .componentSurface
                )
                .cornerRadius(themeConfigurator.sizes.textFieldCornerRadius)
                
                if let errorMessage = errorMessageCardholderName.isNilOrEmptyValue {
                    
                    HStack{
                        Text(errorMessage)
                            .font(
                                themeConfigurator
                                    .typography
                                    .labelSmall
                            )
                            .foregroundColor(
                                themeConfigurator
                                    .colorScheme(colorScheme)
                                    .error
                            )
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
                    placeholder: Localization.rozetka_pay_form_email.description,
                    placeholderFont: themeConfigurator
                        .typography
                        .inputUI,
                    placeholderColor: themeConfigurator
                        .colorScheme(colorScheme)
                        .placeholder
                        .toUIColor(),
                    text: $email,
                    textColor: errorMessagEmail.isNilOrEmpty ?
                    themeConfigurator
                        .colorScheme(colorScheme)
                        .onComponent
                        .toUIColor()
                    :
                        themeConfigurator
                        .colorScheme(
                            colorScheme
                        )
                        .error
                        .toUIColor(),
                    contentType: .emailAddress,
                    keyboardType: .emailAddress,
                    validators: ValidatorsComposer(validators: [
                        EmailValidator()
                    ]),
                    validationTextFieldResult: { result in
                        switch result {
                        case .valid:
                            errorMessagEmail = nil
                        case let .error(message):
                            errorMessagEmail = message
                        }
                    }
                )
                .frame(height: themeConfigurator.sizes.textFieldFrameHeight)
                .padding()
                .background(
                    themeConfigurator
                        .colorScheme(colorScheme)
                        .componentSurface
                )
                .cornerRadius(themeConfigurator.sizes.textFieldCornerRadius)
                
                if let errorMessage = errorMessagEmail.isNilOrEmptyValue {
                    
                    HStack{
                        Text(errorMessage)
                            .font(
                                themeConfigurator
                                    .typography
                                    .labelSmall
                            )
                            .foregroundColor(
                                themeConfigurator
                                    .colorScheme(colorScheme)
                                    .error
                            )
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
                        placeholder: Localization.rozetka_pay_form_card_number.description,
                        placeholderFont: themeConfigurator
                            .typography
                            .inputUI,
                        placeholderColor: themeConfigurator
                            .colorScheme(colorScheme)
                            .placeholder
                            .toUIColor(),
                        text: $cardNumber,
                        textColor:
                            errorMessageCardNumber.isNilOrEmpty ?
                        themeConfigurator
                            .colorScheme(colorScheme)
                            .onComponent
                            .toUIColor()
                        :
                            themeConfigurator
                            .colorScheme(
                                colorScheme
                            )
                            .error
                            .toUIColor(),
                        contentType: .dateTime,
                        keyboardType: .numberPad,
                        maxLength: CardNumberValidator.MAX_CARD_NUMBER_LENGTH,
                        validators: ValidatorsComposer(validators: [
                            CardNumberValidator()
                        ]),
                        validationTextFieldResult: { result in
                            switch result {
                            case .valid:
                                errorMessageCardNumber = nil
                            case let .error(message):
                                errorMessageCardNumber = message
                            }
                        },
                        textMasking: CardNumberMask()
                    )
                    .frame(height: themeConfigurator.sizes.textFieldFrameHeight)
                    .padding()
                    .keyboardType(.numberPad)
                    .background(
                        themeConfigurator
                            .colorScheme(colorScheme)
                            .componentSurface
                    )
                    .clipShape(
                        RoundedCorner(
                            radius: themeConfigurator.sizes.textFieldCornerRadius,
                            corners: [.topLeft, .topRight]
                        )
                    )
                    Image(
                        paymentSystemLogoName,
                        bundle: .module
                    )
                    .resizable()
                    .frame(width: 36, height: 22)
                    .padding(.trailing)
                }
                .background(
                    themeConfigurator
                        .colorScheme(colorScheme)
                        .componentSurface
                )
                .clipShape(
                    RoundedCorner(
                        radius: themeConfigurator.sizes.textFieldCornerRadius,
                        corners: [.topLeft, .topRight]
                    )
                )
                
                HStack(spacing: 2) {
                    InputTextFieldRepresentable(
                        placeholder: Localization.rozetka_pay_form_exp_date.description,
                        placeholderFont: themeConfigurator
                            .typography
                            .inputUI,
                        placeholderColor: themeConfigurator
                            .colorScheme(colorScheme)
                            .placeholder
                            .toUIColor(),
                        text: $expiryDate,
                        textColor:
                            errorMessageExpiryDate.isNilOrEmpty ?
                        themeConfigurator
                            .colorScheme(colorScheme)
                            .onComponent
                            .toUIColor()
                        :
                            themeConfigurator
                            .colorScheme(
                                colorScheme
                            )
                            .error
                            .toUIColor(),
                        contentType: .dateTime,
                        keyboardType: .numberPad,
                        maxLength: CardExpirationDateValidator.MAX_CREDIT_CARD_EXPIRATION_DATE_LENGTH,
                        validators: ValidatorsComposer(validators: [
                            CardExpirationDateValidator(
                                expirationValidationRule: RozetkaPaySdk.validationRules.cardExpirationDateValidationRule
                            )
                        ]),
                        validationTextFieldResult: { result in
                            switch result {
                            case .valid:
                                errorMessageExpiryDate = nil
                            case let .error(message):
                                errorMessageExpiryDate = message
                            }
                        },
                        textMasking: ExpirationDateMask()
                    )
                    .frame(height: themeConfigurator.sizes.textFieldFrameHeight)
                    .padding()
                    .keyboardType(.numberPad)
                    .background(
                        themeConfigurator
                            .colorScheme(colorScheme)
                            .componentSurface
                    )
                    .clipShape(
                        RoundedCorner(
                            radius: themeConfigurator.sizes.textFieldCornerRadius,
                            corners: [.bottomLeft]
                        )
                    )
                    
                    InputTextFieldRepresentable(
                        placeholder: Localization.rozetka_pay_form_cvv.description,
                        placeholderFont: themeConfigurator
                            .typography
                            .inputUI,
                        placeholderColor: themeConfigurator
                            .colorScheme(colorScheme)
                            .placeholder
                            .toUIColor(),
                        text: $cvv,
                        textColor:
                            errorMessageCvv.isNilOrEmpty ?
                        themeConfigurator
                            .colorScheme(colorScheme)
                            .onComponent
                            .toUIColor()
                        :
                            themeConfigurator
                            .colorScheme(colorScheme)
                            .error
                            .toUIColor(),
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
                                errorMessageCvv = nil
                            case let .error(message):
                                errorMessageCvv = message
                            }
                        }
                    )
                    .frame(height: themeConfigurator.sizes.textFieldFrameHeight)
                    .padding()
                    .keyboardType(.numberPad)
                    .background(
                        themeConfigurator
                            .colorScheme(colorScheme)
                            .componentSurface
                    )
                    .clipShape(
                        RoundedCorner(
                            radius: themeConfigurator.sizes.textFieldCornerRadius,
                            corners: [.bottomRight]
                        )
                    )
                }
            }
            .background(
                themeConfigurator
                    .colorScheme(colorScheme)
                    .componentDivider
            )
            .cornerRadius(themeConfigurator.sizes.textFieldCornerRadius)
            
            if let errorMessage = errorMessageExpiryDate.isNilOrEmptyValue ??
                errorMessageCardNumber.isNilOrEmptyValue ??
                errorMessageCvv.isNilOrEmptyValue {
                
                HStack{
                    Text(errorMessage)
                        .font(
                            themeConfigurator
                                .typography
                                .labelSmall
                        )
                        .foregroundColor(
                            themeConfigurator
                                .colorScheme(colorScheme)
                                .error
                        )
                        .padding()
                    Spacer()
                }
            }
        }
    }
    
    //MARK: - checkBox
    private var checkBoxView: some View {
        HStack {
            Toggle("",isOn: $isNeedToTokenizationCard)
                .toggleStyle(
                    CheckBoxStyle(
                        colorOn: themeConfigurator
                            .colorScheme(colorScheme)
                            .primary,
                        colorOff: themeConfigurator
                            .colorScheme(colorScheme)
                            .placeholder
                    )
                )
                .labelsHidden()
            
            Text(Localization.rozetka_pay_form_save_card.description)
                .font(
                    themeConfigurator
                        .typography
                        .labelSmall
                )
                .foregroundColor(
                    themeConfigurator
                        .colorScheme(colorScheme)
                        .onSurface
                )
        }
        .padding()
    }
    
    struct CheckBoxStyle: ToggleStyle {
        let colorOn: Color
        let colorOff: Color
        
        func makeBody(configuration: Configuration) -> some View {
            return Button(action: {
                configuration.isOn.toggle()
            }) {
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                    .resizable()
                    .frame(width: 26, height: 26)
                    .foregroundColor(
                        configuration.isOn ? colorOn : colorOff
                    )
                    .overlay(
                        Image(systemName: "checkmark")
                            .foregroundColor(.white)
                            .opacity(configuration.isOn ? 1 : 0)
                            .padding(4)
                    )
            }
        }
    }
    
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    CardInfoView(
        viewParameters: TokenizationViewParameters(
            cardNameField: .optional,
            emailField: .required,
            cardholderNameField: .optional
        ),
        themeConfigurator: RozetkaPayThemeConfigurator(),
        isNeedToTokenizationCard: .constant(true),
        isShowNeedToTokenizationCard: true,
        cardNumber: .constant("424242"),
        cvv: .constant(nil),
        expiryDate: .constant(nil),
        cardName: .constant(nil),
        cardholderName: .constant(nil),
        email: .constant(nil),
        errorMessageCardNumber: .constant(nil),
        errorMessageCvv: .constant(nil),
        errorMessageExpiryDate: .constant(nil),
        errorMessageCardName: .constant(nil),
        errorMessageCardholderName: .constant(nil),
        errorMessagEmail: .constant(nil)
    )
    
}


