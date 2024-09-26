//
//  LoadingView.swift
//
//
//  Created by Ruslan Kasian Dev on 29.08.2024.
//

import SwiftUI

struct LoadingView: View {
    
    let tintColor: Color
    let textFont: Font
    let textColorDark: Color
    let textColorWhite: Color
    let backgroundColorDark: Color
    let backgroundColorWhite: Color
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .green))
                .scaleEffect(2)
            
            Text(Localization.rozetka_pay_common_loading_message.description)
                .foregroundColor(colorScheme == .dark ? textColorDark : textColorWhite)
                .font(textFont)
        }
        .padding(40)
        .background(
            colorScheme == .dark ? backgroundColorDark.opacity(0.8) : backgroundColorWhite.opacity(0.8)
        )
        .cornerRadius(20)
        .shadow(color: colorScheme == .dark ? backgroundColorWhite.opacity(0.2) : backgroundColorDark.opacity(0.2), radius: 10, x: 0, y: 4)
    }
}
