//
//  LoadingView.swift
//
//
//  Created by Ruslan Kasian Dev on 29.08.2024.
//

import SwiftUI

struct LoadingView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .green))
                .scaleEffect(2)
            
            Text(Localization.rozetka_pay_common_loading_message.description)
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .font(.headline)
        }
        .padding(40)
        .background(
            colorScheme == .dark ? Color.black.opacity(0.8) : Color.white.opacity(0.8)
        )
        .cornerRadius(20)
        .shadow(color: colorScheme == .dark ? Color.white.opacity(0.2) : Color.black.opacity(0.2), radius: 10, x: 0, y: 4)
    }
}
