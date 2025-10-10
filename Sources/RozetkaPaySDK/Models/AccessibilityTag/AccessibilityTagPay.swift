//
//  AccessibilityTagPay.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 29.09.2025.
//

extension AccessibilityTag {
    
    struct Pay {

        private func makeID(_ key: String) -> String {
            return "\(base).\(key)"
        }
        
        var base: String {
            "pay"
        }
        
        var headerTitle: String {
            makeID("headerTitle")
        }
        var cardInfoView: String {
            makeID("cardInfoView")
        }
        
        var cardInfoFooter: String {
            makeID("cardInfoFooterView")
        }
        var threeDSView: String {
            makeID("threeDSView")
        }
        var cardPayButton: String {
            makeID("cardPayButton")
        }
        var applePayButton: String {
            makeID("applePayButton")
        }
        
        var closeButton: String {
            makeID("closeButton")
        }
        var legalView: String {
            makeID("legalView")
        }
        var loadingView: String {
            makeID("loadingView")
        }
        var errorView: String {
            makeID("errorView")
        }
    }
}
