//
//  AccessibilityTagLoading.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 29.09.2025.
//


extension AccessibilityTag {
    
    struct Loading {
        private let namespace: String?
        private let base: String = "loadingView"
        
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
        
        var title: String {
            makeID("title")
        }
        var progress: String {
            makeID("progress")
        }
    }
}
