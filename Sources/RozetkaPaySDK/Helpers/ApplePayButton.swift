//
//  File.swift
//  
//
//  Created by Ruslan Kasian Dev on 29.08.2024.
//

import SwiftUI
import PassKit

public struct ApplePayButton: UIViewRepresentable {
    private var action: () -> Void
    private var paymentButtonStyle: PKPaymentButtonStyle
    
    public init(action: @escaping () -> Void,
                paymentButtonStyle: PKPaymentButtonStyle = .automatic
    ) {
        self.action = action
        self.paymentButtonStyle = paymentButtonStyle
    }
    
    
    public func makeUIView(context: Context) -> PKPaymentButton {
        let button = PKPaymentButton(
            paymentButtonType: .plain,
            paymentButtonStyle: paymentButtonStyle
        )
        button.addTarget(
            context.coordinator,
            action: #selector(Coordinator.buttonTapped),
            for: .touchUpInside
        )
        return button
    }
    
    public func updateUIView(_ uiView: PKPaymentButton, context: Context) {}
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(action: action)
    }
}

extension ApplePayButton {
    public class Coordinator: NSObject {
        var action: () -> Void
        
        init(action: @escaping () -> Void) {
            self.action = action
        }
        
        @objc func buttonTapped() {
            action()
        }
    }
}
