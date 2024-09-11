//
//  File.swift
//
//
//  Created by Ruslan Kasian Dev on 10.09.2024.
//

import SwiftUI

struct ErrorView: View {
    private enum Constants {
        static let textFieldCornerRadius: CGFloat = 16
        static let textFieldFrameHeight: CGFloat = 22
        static let buttonCornerRadius: CGFloat = 16
    }
    
    var errorMessage: String
    var onCancel: () -> Void
    var onRetry: () -> Void
    
    init(
        errorMessage: String? = nil,
        onCancel: @escaping () -> Void,
        onRetry: @escaping () -> Void
    ) {
        self.errorMessage = errorMessage ?? Localization.rozetka_pay_tokenization_error_common.description
        self.onCancel = onCancel
        self.onRetry = onRetry
    }
    
    var body: some View {
        VStack {
            Spacer()

            
            // Illustration Image
            Image("rozetka_pay_error", bundle: .module)
                .resizable()
                .frame(width: 200, height: 200)
                .foregroundColor(.green)
                .padding()
            
            // Error Message
            Text(errorMessage)  // Using the errorMessage parameter here
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.bottom, 20)
            
            // Buttons
            VStack(spacing: 16) {
                Button(action: onCancel) {
                    Text(Localization.rozetka_pay_common_button_cancel.description)
                        .foregroundColor(.green)
                        .font(.system(size: 18, weight: .medium))
                }
                
                Button(action: {
                    onRetry()
                }) {
                    Text(Localization.rozetka_pay_common_button_retry.description)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(Constants.buttonCornerRadius)
                }
//                .padding(.top, )
                
                
                .padding(.horizontal, 20)
            }
            
            Spacer()
        }
        .background(Color(.systemGray6))
        .cornerRadius(20)
        .padding()
    }
}

#Preview {
    ErrorView(
//        errorMessage: "test",  // Example error message
        onCancel: { print("Cancel tapped") },
        onRetry: { print("Retry tapped") }
    )
}
