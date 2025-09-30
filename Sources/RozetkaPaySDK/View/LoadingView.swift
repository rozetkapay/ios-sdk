//
//  LoadingView.swift
//
//
//  Created by Ruslan Kasian Dev on 29.08.2024.
//

import SwiftUI

struct LoadingView: View {
    // MARK: - Properties
    @Environment(\.colorScheme) var colorScheme
    private let themeConfigurator: RozetkaPayThemeConfigurator
    private let isExpanded: Bool
    private let accessibilityNamespace: String
    private var tags: AccessibilityTag.Loading {
        AccessibilityTag.Loading(namespace: accessibilityNamespace)
    }
    
    init(
        accessibilityNamespace: String,
        themeConfigurator: RozetkaPayThemeConfigurator,
        isExpanded: Bool = true
    ) {
        self.accessibilityNamespace = accessibilityNamespace
        self.themeConfigurator = themeConfigurator
        self.isExpanded = isExpanded
    }
    
    var body: some View {
        contentView
    }
}

//MARK: UI
private extension LoadingView {
    
    @ViewBuilder
    private var contentView: some View {
        if isExpanded {
            mainViewExpanded
        } else {
            mainViewCompact
        }
    }
    
    ///
    var mainViewCompact: some View {
        mainContent
            .padding(40)
            .background(backgroundView)
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
    
    ///
    var mainViewExpanded: some View {
        mainContent
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity
            )
            .background(backgroundView)
    }
    
    ///
    var mainContent: some View {
        VStack(spacing: 20) {
            ProgressView()
                .progressViewStyle(
                    CircularProgressViewStyle(tint:
                        themeConfigurator
                            .colorScheme(colorScheme)
                            .primary
                        )
                )
                .scaleEffect(2)
                .accessibilityIdentifier(tags.progress)
            
            Text(Localization.rozetka_pay_common_loading_message.description)
                .accessibilityIdentifier(tags.title)
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
        }
    }
    
    ///
    var backgroundView: some View {
        themeConfigurator
            .colorScheme(colorScheme)
            .surface
            .opacity(0.8)
    }
}

//MARK: Preview
#Preview {
    LoadingView(
        accessibilityNamespace: "test",
        themeConfigurator: RozetkaPayThemeConfigurator(mode: .dark)
    )
}
