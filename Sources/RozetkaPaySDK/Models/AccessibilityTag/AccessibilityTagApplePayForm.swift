//
//  AccessibilityTagApplePayForm.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 03.07.2026.
//

extension AccessibilityTag {

    struct ApplePayForm {

        private func makeID(_ key: String) -> String {
            return "\(base).\(key)"
        }

        var base: String {
            "applePayForm"
        }

        var applePayButton: String {
            makeID("applePayButton")
        }

        var threeDSView: String {
            makeID("threeDSView")
        }
    }
}
