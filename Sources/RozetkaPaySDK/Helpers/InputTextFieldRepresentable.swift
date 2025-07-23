//
//  File.swift
//  
//
//  Created by Ruslan Kasian Dev on 28.08.2024.
//

import UIKit
import SwiftUI

public struct InputTextFieldRepresentable: UIViewRepresentable {
    @Binding private var text: String?
    
    private let appearance: UIUserInterfaceStyle
    private let placeholder: String?
    private let placeholderFont: UIFont
    private let placeholderColor: UIColor
    private let isSecure: Bool
    private let contentType: UITextContentType?
    private let rightViewMode: UITextField.ViewMode
    private let passwordRules: UITextInputPasswordRules?
    private let keyboardType: UIKeyboardType
    private let textFont: UIFont
    private let textColor: UIColor
    private let backgroundColor: UIColor
    private let textField: InsetTextField = InsetTextField()
    
    private let maxLength: Int
    private let isRequired: Bool
    private let validators: ValidatorsComposer?
    private let validationTextFieldResult: ValidationTextFieldResult?
    private let textMasking: TextMasking?
    
    private let clearButton: UIButton
    
    public init(
        appearance: UIUserInterfaceStyle,
        placeholder: String? = nil,
        placeholderFont: UIFont = UIFont.systemFont(ofSize: 16),
        placeholderColor: UIColor = UIColor.gray,
        text: Binding<String?>,
        textFont: UIFont = UIFont.systemFont(ofSize: 16),
        textColor: UIColor = UIColor.black,
        backgroundColor: UIColor = UIColor.clear,
        isSecure: Bool = false,
        contentType: UITextContentType? = nil,
        rightViewMode: UITextField.ViewMode = .never,
        passwordRules: UITextInputPasswordRules? = nil,
        keyboardType: UIKeyboardType = .default,
        maxLength: Int = -1,
        isRequired: Bool = true,
        validators: ValidatorsComposer? = nil,
        validationTextFieldResult: ValidationTextFieldResult? = nil,
        textMasking: TextMasking? = nil
    ) {
        self.appearance = appearance
        self.placeholder = placeholder
        self.placeholderFont = placeholderFont
        self.placeholderColor = placeholderColor
        self._text = text
        self.textFont = textFont
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.isSecure = isSecure
        self.contentType = contentType
        self.rightViewMode = rightViewMode
        self.passwordRules = passwordRules
        self.keyboardType = keyboardType
        self.maxLength = maxLength
        self.isRequired = isRequired
        self.validators = validators
        self.validationTextFieldResult = validationTextFieldResult
        self.textMasking = textMasking
        
        self.clearButton =  {
            let btn = UIButton(type: .system)
            if let image = DomainImages.xmarkCircle.image(appearance) {
                btn.setImage(image, for: .normal)
                btn.frame = CGRect(origin: .zero, size: image.size)
                btn.tintColor = .gray
            }
            return btn
        }()
    }
    
    public func makeUIView(context: Context) -> UITextField {
        if rightViewMode != .never {
            configureClearButton()
            textField.rightViewMode = self.rightViewMode
            textField.rightView = clearButton
        }
        textField.delegate = context.coordinator
        textField.textContentType = self.contentType
        textField.borderStyle = .none
        textField.keyboardType = self.keyboardType
       
        textField.font = self.textFont
        textField.textColor = self.textColor
        textField.backgroundColor = self.backgroundColor
        textField.isSecureTextEntry = isSecure
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.passwordRules = self.passwordRules
        textField.placeholder = self.placeholder
        
        textField.attributedPlaceholder = NSAttributedString(
            string: self.placeholder ?? "",
            attributes: [
                .font: self.placeholderFont,
                .foregroundColor: self.placeholderColor
            ]
        )
        
        textField.textInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
        textField.rightViewInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 15)
        
        if keyboardType == .numberPad {
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(
                title: Localization.rozetka_pay_common_button_done.description,
                style: .done,
                target: context.coordinator,
                action: #selector(Coordinator.dismissKeyboard)
            )
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            toolbar.setItems([flexibleSpace, doneButton], animated: false)
            textField.inputAccessoryView = toolbar
        }else {
            textField.returnKeyType = .done
            textField.addTarget(context.coordinator, action: #selector(Coordinator.dismissKeyboard), for: .editingDidEnd)
        }
        return textField
    }
    
    public func updateUIView(_ uiView: UITextField, context: Context) {
        if uiView.text != self.text {
            uiView.text = self.text
        }
        uiView.textColor = self.textColor
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    // MARK: - Private methods
    private func configureClearButton() {
        var action: UIAction!
        
        if isSecure {
            clearButton.setImage(
                DomainImages.eye.image(appearance),
                for: .normal
            )
            action = UIAction { _ in
                self.textField.isSecureTextEntry.toggle()
                self.clearButton.setImage(
                    self.textField.isSecureTextEntry ?
                    DomainImages.eye.image(appearance) :
                    DomainImages.eyeSlash.image(appearance),
                    for: .normal)
            }
        } else {
            clearButton.setImage(DomainImages.xmarkCircle.image(appearance), for: .normal)
            action = UIAction { _ in
                if self.textField.delegate?.textFieldShouldClear?(self.textField) ?? true {
                    self.textField.text = nil
                    self.textField.sendActions(for: .editingChanged)
                }
            }
        }
        
        clearButton.addAction(action, for: .touchUpInside)
    }
}

extension InputTextFieldRepresentable {
    public class Coordinator: NSObject, UITextFieldDelegate {
        let parent: InputTextFieldRepresentable
        
        public init(parent: InputTextFieldRepresentable) {
            self.parent = parent
            super.init()
        }
        
        public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if range.location == 0 && range.length == 0 && string == " " {
                return false
            }
            
            guard let currentText = textField.text as NSString? else {
                return false
            }
            var newText = currentText.replacingCharacters(in: range, with: string)
            
            if parent.maxLength > 0 && newText.count > parent.maxLength {
                return false
            }
            
            if let textMasking = parent.textMasking {
                newText = textMasking.format(text: newText)
            }
            parent.text = newText
            
            if let validators = parent.validators {                
                if parent.isRequired || !newText.isNilOrEmpty {
                    parent.validationTextFieldResult?(
                        validators.validate(value: newText)
                    )
                } else {
                    parent.validationTextFieldResult?(.valid)
                }
            }
            
            return true
        }
    
        public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return false
        }
        
        @objc func dismissKeyboard() {
            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder),
                to: nil,
                from: nil,
                for: nil
            )
        }
    }
}
