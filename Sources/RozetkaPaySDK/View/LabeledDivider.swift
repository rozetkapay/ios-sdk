//
//  LabeledDivider.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 24.07.2025.
//


import SwiftUI

struct LabeledDivider: View {
    
    //MARK: - Properties
    @Environment(\.colorScheme) var colorScheme
    private let themeConfigurator: RozetkaPayThemeConfigurator
    private let label: String

    init(
        label: String,
        _ themeConfigurator: RozetkaPayThemeConfigurator
    ) {
        self.label = label
        self.themeConfigurator = themeConfigurator
    }

    var body: some View {
        HStack {
            line
            Text(label)
                .font(
                    themeConfigurator
                        .typography
                        .labelSmall
                )
                .foregroundColor(
                    themeConfigurator
                        .colorScheme(colorScheme)
                        .subtitle
                )
            line
                
        }
        .padding([.top, .bottom], 16)
    }
    
    private var line: some View {
        Rectangle()
            .fill(
                themeConfigurator
                    .colorScheme(colorScheme)
                    .componentDivider
            )
            .frame(height: 1)
    }
}

#Preview {
    LabeledDivider(label: "Or pay using card", RozetkaPayThemeConfigurator())
}
