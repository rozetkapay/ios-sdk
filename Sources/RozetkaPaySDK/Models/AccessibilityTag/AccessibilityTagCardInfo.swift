//
//  AccessibilityTagCardInfo.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 29.09.2025.
//


extension AccessibilityTag {
    
    struct CardInfo {
        
        private let namespace: String?
        private let base: String = "cardInfo"
        
        init(namespace: String? = nil) {
            self.namespace = namespace
        }
        
        private func makeID(_ key: String) -> String {
            if let namespace {
                return "\(namespace).\(base).\(key)"
            } else {
                return "\(base).\(key)"
            }
        }
        
        var cardNumber: String {
            makeID("cardNumberField")
        }
        
        var cvv: String {
            makeID("cvvField")
        }
        var expiryDate: String {
            makeID("expiryDateField")
        }
        
        var cardDetailsError: String {
            makeID("cardDetailsError")
        }
        
        var cardName: String {
            makeID("cardNameField")
        }
        
        var cardNameError: String {
            makeID("cardNameError")
        }
        
        var cardHolderName: String {
            makeID("cardHolderNameField")
        }
        
        var cardHolderNameError: String {
            makeID("cardHolderNameError")
        }
        
        var email: String {
            makeID("emailField")
        }
        
        var emailError: String {
            makeID("emailError")
        }
    }
}
