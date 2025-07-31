//
//  LoadingView.swift
//
//
//  Created by Ruslan Kasian Dev on 29.08.2024.
//

import SwiftUI

struct LoadingView: View {
    //MARK: - Properties
    @Environment(\.colorScheme) var colorScheme
    private let themeConfigurator: RozetkaPayThemeConfigurator
    
    init(themeConfigurator: RozetkaPayThemeConfigurator) {
        self.themeConfigurator = themeConfigurator
    }
    
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .green))
                .scaleEffect(2)
            
            Text(Localization.rozetka_pay_common_loading_message.description)
                .foregroundColor(
                    themeConfigurator
                        .colorScheme(colorScheme)
                        .onSurface
                )
                .font(
                    themeConfigurator
                        .typography
                        .body
                )
                .lineSpacing(
                    themeConfigurator
                        .typography
                        .bodyLineSpacing
                )
        }
        .padding(40)
        .background(
            themeConfigurator
                .colorScheme(colorScheme)
                .surface
                .opacity(0.8)
        )
        .cornerRadius(20)
        .shadow(
            color: themeConfigurator
                .colorScheme(colorScheme)
                .surface
                .opacity(0.2),
            radius: 10,
            x: 0,
            y: 4
        )
    }
}

//MARK: Preview
#Preview {
    LoadingView(themeConfigurator: RozetkaPayThemeConfigurator(mode: .dark))
}
