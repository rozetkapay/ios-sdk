//
//  AccessibilityTagTokenization.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 29.09.2025.
//

extension AccessibilityTag {
    struct Tokenization {

        private func makeID(_ key: String) -> String {
            return "\(base).\(key)"
        }
        
        var base: String {
            "tokenization"
        }
        
        var headerTitle: String {
            makeID("headerTitle")
        }
        
        var cardInfoView: String {
            makeID("cardInfoView")
        }
        
        var mainButton: String {
            makeID("mainButton")
        }
        
        var closeButton: String {
            makeID("closeButton")
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
