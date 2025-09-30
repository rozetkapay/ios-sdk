//
//  AccessibilityTagError.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 29.09.2025.
//

extension AccessibilityTag {
    
    struct Error {
        
        private let namespace: String?
        private let base: String = "errorView"
        
        
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
        
        var message: String {
            makeID("message")
        }
        
        var image: String {
            makeID("image")
        }
        
        var mainButton: String {
            makeID("mainButton")
        }
        
        var secondButton: String {
            makeID("secondButton")
        }
    }
}
