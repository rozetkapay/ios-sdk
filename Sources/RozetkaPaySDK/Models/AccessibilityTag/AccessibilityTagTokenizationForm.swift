//
//  AccessibilityTagTokenizationForm.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 29.09.2025.
//


extension AccessibilityTag {
    
    struct TokenizationForm {

        private func makeID(_ key: String) -> String {
            return "\(base).\(key)"
        }
        
        var base: String {
            "tokenizationForm"
        }
        
        var cardFormFooterEmbeddedContent: String {
            makeID("cardFormFooterEmbeddedContent")
        }
        
        var cardInfoView: String {
            makeID("cardInfoView")
        }
        
        var mainButton: String {
            makeID("mainButton")
        }
        
        var cardInfoFooter: String {
            makeID("cardInfoFooterView")
        }
        
        var loadingView: String {
            makeID("loadingView")
        }
        
        var errorView: String {
            makeID("errorView")
        }
    }
}
