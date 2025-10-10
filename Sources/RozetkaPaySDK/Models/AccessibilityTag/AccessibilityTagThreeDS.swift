//
//  AccessibilityTagThreeDS.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 29.09.2025.
//

extension AccessibilityTag {
    
    struct ThreeDS {
        
        private let namespace: String?
        private let base: String = "threeDS"
        
        
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
        
        var transitionBase: String {
            if let namespace {
                return "\(namespace).\(base)"
            } else {
                return "\(base)"
            }
        }
        
        var webViewWrapper: String {
            makeID("threeDSWebViewWrapper")
        }
        
        var closeButton: String {
            makeID("closeButton")
        }

        var loadingView: String {
            makeID("loadingView")
        }
        
        var errorView: String {
            makeID("errorView")
        }
    }
}
