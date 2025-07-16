//
//  CardInfoView.swift
//
//
//  Created by Ruslan Kasian Dev on 13.09.2024.
//

import SwiftUI

public struct CardInfoView: View {
    
    //MARK: - Properties
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
    @Binding var errorMessageEmail: String?
    
    //MARK: - Properties
    private let provideCardPaymentSystemUseCase: ProvideCardPaymentSystemUseCase
    private let themeConfigurator: RozetkaPayThemeConfigurator
    
    private let fieldRequirementCardName: FieldRequirement
    private let fieldRequirementCardholderName: FieldRequirement
    private let fieldRequirementEmail: FieldRequirement
    private let isVisibleCardInfoTitle: Bool
    private let cardInfoTitleText: String

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
        errorMessageEmail: Binding<String?>
    ) {
        ///
        self.themeConfigurator = themeConfigurator
        self.provideCardPaymentSystemUseCase = provideCardPaymentSystemUseCase ?? ProvideCardPaymentSystemUseCase()
        self.fieldRequirementCardName = viewParameters.cardNameField
        self.fieldRequirementCardholderName = viewParameters.cardholderNameField
        self.fieldRequirementEmail = viewParameters.emailField
        self.isVisibleCardInfoTitle = viewParameters.isVisibleCardInfoTitle
        self.cardInfoTitleText = viewParameters.stringResources.cardFormTitle
        ///
        self._cardNumber = cardNumber
        self._cvv = cvv
        self._expiryDate = expiryDate
        self._cardName = cardName
        self._cardholderName = cardholderName
        self._email = email
        ///
        self._errorMessageCardNumber = errorMessageCardNumber
        self._errorMessageCvv = errorMessageCvv
        self._errorMessageExpiryDate = errorMessageExpiryDate
        self._errorMessageCardName = errorMessageCardName
        self._errorMessageCardholderName = errorMessageCardholderName
        self._errorMessageEmail = errorMessageEmail
        ///
        self._detectedPaymentSystem = State(initialValue: self.detectPaymentSystem(cardNumber.wrappedValue))
    }
    
    public var body: some View {
        Group {
            if fieldRequirementCardName.isVisible {
                VStack(spacing: 16) {
                    cardNameView
                }
            }
            if isVisibleCardInfoTitle {
                HStack{
                    Text(cardInfoTitleText)
                        
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
                        .padding(.top, 16)
                    Spacer()
                }
            }
            VStack(spacing: 16) {
                cardDetailsView
                
                if fieldRequirementCardholderName.isVisible {
                    cardHolderNameView
                }
                
                if fieldRequirementEmail.isVisible {
                    emailView
                }
            }
            
        }
        .onChange(of: cardNumber) { newValue in
            self.detectedPaymentSystem = self.detectPaymentSystem(newValue)
        }
    }
    
}

//MARK: UI
private extension CardInfoView {
    
    ///
    var cardNameView: some View {
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
                    keyboardType: .default,
                    isRequired: fieldRequirementCardName.isRequired,
                    validators: ValidatorsComposer(validators: [
                        CardNameValidator()
                    ]),
                    validationTextFieldResult: { result in
                        switch result {
                        case .valid:
                            errorMessageCardName = nil
                        case let .error(message):
                            errorMessageCardName = message
                        }
                    }
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
                        .componentCornerRadius
                )
                
                if let errorMessage = errorMessageCardName.isNilOrEmptyValue {
                    
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
    
    ///
    var cardHolderNameView: some View {
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
                    isRequired: fieldRequirementCardholderName.isRequired,
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
                .cornerRadius(
                    themeConfigurator
                        .sizes
                        .componentCornerRadius
                )
                
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
    
    ///
    var emailView: some View {
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
                    textColor: errorMessageEmail.isNilOrEmpty ?
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
                    isRequired: fieldRequirementEmail.isRequired,
                    validators: ValidatorsComposer(validators: [
                        EmailValidator()
                    ]),
                    validationTextFieldResult: { result in
                        switch result {
                        case .valid:
                            errorMessageEmail = nil
                        case let .error(message):
                            errorMessageEmail = message
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
                .cornerRadius(
                    themeConfigurator
                        .sizes
                        .componentCornerRadius
                )
                
                if let errorMessage = errorMessageEmail.isNilOrEmptyValue {
                    
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
    
    ///
    var cardNumberView: some View {
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
                    radius: themeConfigurator
                        .sizes
                        .componentCornerRadius,
                    corners: [
                        .topLeft,
                        .topRight
                    ]
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
                radius: themeConfigurator
                    .sizes
                    .componentCornerRadius,
                corners: [
                    .topLeft,
                    .topRight
                ]
            )
        )
    }
    
    ///
    var expDateView: some View {
        HStack {
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
                    radius: themeConfigurator
                        .sizes
                        .componentCornerRadius,
                    corners: [
                        .bottomLeft
                    ]
                )
            )
        }
    }
    
    ///
    var cvvView: some View {
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
                radius:
                    themeConfigurator
                    .sizes
                    .componentCornerRadius,
                corners: [
                    .bottomRight
                ]
            )
        )
    }
    ///
    var cardDetailsView: some View {
        VStack(spacing: 0) {
            VStack(
                spacing:
                    themeConfigurator
                    .sizes
                    .borderWidth
            ) {
                cardNumberView
                
                HStack(
                    spacing:
                        themeConfigurator
                        .sizes
                        .borderWidth
                ) {
                    expDateView
                    cvvView
                }
            }
            .background(
                themeConfigurator
                    .colorScheme(colorScheme)
                    .componentDivider
            )
            .cornerRadius(
                themeConfigurator
                    .sizes
                    .componentCornerRadius
            )
            
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
}

//MARK: Private Methods
private extension CardInfoView {
    
    @discardableResult
    func detectPaymentSystem(_ value: String?) -> PaymentSystem? {
        return provideCardPaymentSystemUseCase.invoke(cardNumberPrefix: value)
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

//MARK: Preview
#Preview {
    CardInfoView(
        viewParameters: TokenizationContentViewParameters(
            cardNameField: .optional,
            emailField: .required,
            cardholderNameField: .optional
        ),
        themeConfigurator: RozetkaPayThemeConfigurator(),
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
        errorMessageEmail: .constant(nil)
    )
    
}
