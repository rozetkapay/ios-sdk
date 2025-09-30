//
//  CardInfoView.swift
//
//
//  Created by Ruslan Kasian Dev on 13.09.2024.
//

import SwiftUI

public struct CardInfoView: View {
    
    //MARK: - Constants & Defaults
    private enum Constants {
        static let vStackSpacing: CGFloat = 16
        static let cardInfoTitleBottomSpacing: CGFloat = 10
    }
    
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
    @Binding var cardNumberStatus: ValidationResult
    @Binding var cvvStatus: ValidationResult
    @Binding var expiryDateStatus: ValidationResult
    @Binding var cardNameStatus: ValidationResult
    @Binding var cardholderNameStatus: ValidationResult
    @Binding var emailStatus: ValidationResult
    
    @Environment(\.colorScheme) var colorScheme
    
    //MARK: - Properties
    private let provideCardPaymentSystemUseCase: ProvideCardPaymentSystemUseCase
    private let themeConfigurator: RozetkaPayThemeConfigurator
    
    private let fieldRequirementCardName: FieldRequirement
    private let fieldRequirementCardholderName: FieldRequirement
    private let fieldRequirementEmail: FieldRequirement
    private let isVisibleCardInfoTitle: Bool
    private let cardInfoTitleText: String
    
    @State var detectedPaymentSystem: PaymentSystem?
    
    private var paymentSystemLogo: DomainImages {
        detectedPaymentSystem?.logo ?? PaymentSystem.defaultLogo
    }
    
    private let accessibilityNamespace: String
    private var tags: AccessibilityTag.CardInfo {
        AccessibilityTag.CardInfo(namespace: accessibilityNamespace)
    }
    
    //MARK: - Init
    public init(
        accessibilityNamespace: String,
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
        cardNumberStatus: Binding<ValidationResult>,
        cvvStatus: Binding<ValidationResult>,
        expiryDateStatus: Binding<ValidationResult>,
        cardNameStatus: Binding<ValidationResult>,
        cardholderNameStatus: Binding<ValidationResult>,
        emailStatus: Binding<ValidationResult>
    ) {
        ///
        self.accessibilityNamespace = accessibilityNamespace
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
        self._cardNumberStatus = cardNumberStatus
        self._cvvStatus = cvvStatus
        self._expiryDateStatus = expiryDateStatus
        self._cardNameStatus = cardNameStatus
        self._cardholderNameStatus = cardholderNameStatus
        self._emailStatus = emailStatus
        
        self._detectedPaymentSystem = State(initialValue: self.detectPaymentSystem(cardNumber.wrappedValue))
    }
    
    public var body: some View {
        VStack(spacing: Constants.vStackSpacing) {
            if fieldRequirementCardName.isVisible {
                cardNameView
            }
            
            VStack(spacing: Constants.cardInfoTitleBottomSpacing) {
                if isVisibleCardInfoTitle {
                    HStack{
                        Text(cardInfoTitleText)
                            .font(
                                themeConfigurator
                                    .typography
                                    .subtitle
                            )
                            .foregroundColor(
                                themeConfigurator
                                    .colorScheme(colorScheme)
                                    .subtitle
                            )
                            .padding(.top, 16)
                        Spacer()
                    }
                }
                cardDetailsView
            }
            
            if fieldRequirementCardholderName.isVisible {
                cardHolderNameView
            }
            
            if fieldRequirementEmail.isVisible {
                emailView
            }
        }
        .padding(.top, themeConfigurator.sizes.cardInfoTopPadding)
        .onChange(of: cardNumber) { newValue in
            self.detectedPaymentSystem = self.detectPaymentSystem(newValue)
        }
    }
    
}

//MARK: UI
private extension CardInfoView {
    
    ///
    var cardNameView: some View {
        VStack(spacing: 0){
            InputTextFieldRepresentable(
                appearance: themeConfigurator.colorScheme(colorScheme),
                placeholder: Localization.rozetka_pay_form_card_name.description,
                placeholderFont: themeConfigurator
                    .typography
                    .inputUI,
                placeholderColor: themeConfigurator
                    .colorScheme(colorScheme)
                    .placeholder
                    .toUIColor(),
                text: $cardName,
                textFont: themeConfigurator
                    .typography
                    .inputUI,
                textColor: themeConfigurator
                    .colorScheme(colorScheme)
                    .onComponent
                    .toUIColor(),
                errorTextColor: themeConfigurator
                    .colorScheme(colorScheme)
                    .error
                    .toUIColor(),
                contentType: .name,
                keyboardType: .default,
                isRequired: fieldRequirementCardName.isRequired,
                validators: ValidatorsComposer(validators: [
                    CardNameValidator()
                ]),
                validationStatus: $cardNameStatus
            )
            .accessibilityIdentifier(tags.cardName)
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
            
            if let errorMessage = cardNameStatus.errorMessage {
                FieldErrorView(message: errorMessage, themeConfigurator)
                    .accessibilityIdentifier(tags.cardNameError)
            }
        }
    }
    
    ///
    var cardHolderNameView: some View {
        VStack(spacing: 0) {
            InputTextFieldRepresentable(
                appearance: themeConfigurator.colorScheme(colorScheme),
                placeholder: Localization.rozetka_pay_form_cardholder_name.description,
                placeholderFont: themeConfigurator
                    .typography
                    .inputUI,
                placeholderColor: themeConfigurator
                    .colorScheme(colorScheme)
                    .placeholder
                    .toUIColor(),
                text: $cardholderName,
                textFont: themeConfigurator
                    .typography
                    .inputUI,
                textColor: themeConfigurator
                    .colorScheme(colorScheme)
                    .onComponent
                    .toUIColor(),
                errorTextColor: themeConfigurator
                    .colorScheme(colorScheme)
                    .error
                    .toUIColor(),
                contentType: .name,
                keyboardType: .default,
                isRequired: fieldRequirementCardholderName.isRequired,
                validators: ValidatorsComposer(validators: [
                    CardholderNameValidator()
                ]),
                validationStatus: $cardholderNameStatus
            )
            .accessibilityIdentifier(tags.cardHolderName)
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
            
            if let errorMessage = cardholderNameStatus.errorMessage {
                FieldErrorView(message: errorMessage, themeConfigurator)
                    .accessibilityIdentifier(tags.cardHolderNameError)
            }
        }
    }
    
    ///
    var emailView: some View {
        VStack(spacing: 0) {
            InputTextFieldRepresentable(
                appearance: themeConfigurator.colorScheme(colorScheme),
                placeholder: Localization.rozetka_pay_form_email.description,
                placeholderFont: themeConfigurator
                    .typography
                    .inputUI,
                placeholderColor: themeConfigurator
                    .colorScheme(colorScheme)
                    .placeholder
                    .toUIColor(),
                text: $email,
                textFont: themeConfigurator
                    .typography
                    .inputUI,
                textColor: themeConfigurator
                    .colorScheme(colorScheme)
                    .onComponent
                    .toUIColor(),
                errorTextColor: themeConfigurator
                    .colorScheme(colorScheme)
                    .error
                    .toUIColor(),
                contentType: .emailAddress,
                keyboardType: .emailAddress,
                isRequired: fieldRequirementEmail.isRequired,
                validators: ValidatorsComposer(validators: [
                    EmailValidator()
                ]),
                validationStatus: $emailStatus
            )
            .accessibilityIdentifier(tags.email)
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
            
            if let errorMessage = emailStatus.errorMessage {
                FieldErrorView(message: errorMessage, themeConfigurator)
                    .accessibilityIdentifier(tags.emailError)
            }
        }
    }
    
    ///
    var cardNumberView: some View {
        HStack {
            InputTextFieldRepresentable(
                appearance: themeConfigurator.colorScheme(colorScheme),
                placeholder: Localization.rozetka_pay_form_card_number.description,
                placeholderFont: themeConfigurator
                    .typography
                    .inputUI,
                placeholderColor: themeConfigurator
                    .colorScheme(colorScheme)
                    .placeholder
                    .toUIColor(),
                text: $cardNumber,
                textFont: themeConfigurator
                    .typography
                    .inputUI,
                textColor: themeConfigurator
                    .colorScheme(colorScheme)
                    .onComponent
                    .toUIColor(),
                errorTextColor: themeConfigurator
                    .colorScheme(colorScheme)
                    .error
                    .toUIColor(),
                contentType: .dateTime,
                keyboardType: .numberPad,
                maxLength: CardNumberValidator.MAX_CARD_NUMBER_LENGTH_WITH_SPACES,
                validators: ValidatorsComposer(validators: [
                    CardNumberValidator()
                ]),
                validationStatus: $cardNumberStatus,
                textMasking: CardNumberMask()
            )
            .accessibilityIdentifier(tags.cardNumber)
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
            
            paymentSystemLogo.image(themeConfigurator.colorScheme(colorScheme))
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
                appearance: themeConfigurator.colorScheme(colorScheme),
                placeholder: Localization.rozetka_pay_form_exp_date.description,
                placeholderFont: themeConfigurator
                    .typography
                    .inputUI,
                placeholderColor: themeConfigurator
                    .colorScheme(colorScheme)
                    .placeholder
                    .toUIColor(),
                text: $expiryDate,
                textFont: themeConfigurator
                    .typography
                    .inputUI,
                textColor: themeConfigurator
                    .colorScheme(colorScheme)
                    .onComponent
                    .toUIColor(),
                errorTextColor: themeConfigurator
                    .colorScheme(colorScheme)
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
                validationStatus: $expiryDateStatus,
                textMasking: ExpirationDateMask()
            )
            .accessibilityIdentifier(tags.expiryDate)
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
            appearance: themeConfigurator.colorScheme(colorScheme),
            placeholder: Localization.rozetka_pay_form_cvv.description,
            placeholderFont: themeConfigurator
                .typography
                .inputUI,
            placeholderColor: themeConfigurator
                .colorScheme(colorScheme)
                .placeholder
                .toUIColor(),
            text: $cvv,
            textFont: themeConfigurator
                .typography
                .inputUI,
            textColor: themeConfigurator
                .colorScheme(colorScheme)
                .onComponent
                .toUIColor(),
            errorTextColor: themeConfigurator
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
            validationStatus: $cvvStatus
        )
        .accessibilityIdentifier(tags.cvv)
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
            
            if let errorMessage = cardNumberStatus.errorMessage ??
                expiryDateStatus.errorMessage ??
                cvvStatus.errorMessage {
                FieldErrorView(message: errorMessage, themeConfigurator)
                    .accessibilityIdentifier(tags.cardDetailsError)
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
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}

//MARK: Preview
#Preview {
    CardInfoView(
        accessibilityNamespace: "test",
        viewParameters: TokenizationFormViewParameters(
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
        cardNumberStatus: .constant(.none),
        cvvStatus: .constant(.none),
        expiryDateStatus: .constant(.none),
        cardNameStatus: .constant(.none),
        cardholderNameStatus:.constant(.none),
        emailStatus: .constant(.none)
    )
    
}
