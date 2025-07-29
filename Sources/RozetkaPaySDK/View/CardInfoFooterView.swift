//
//  CardInfoFooterView.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 29.05.2025.
//
import SwiftUI

public struct CardInfoFooterView: View {
    
    @Environment(\.colorScheme) var colorScheme
    private let themeConfigurator: RozetkaPayThemeConfigurator
    
    init(themeConfigurator: RozetkaPayThemeConfigurator) {
        self.themeConfigurator = themeConfigurator
    }

    public var body: some View {
        HStack {
            Spacer()
            DomainImages.legalVisa.image(
                themeConfigurator
                .colorScheme(colorScheme)
            )
            DomainImages.legalPcidss.image(
                themeConfigurator
                .colorScheme(colorScheme)
            )
            DomainImages.legalMastercard.image(
                themeConfigurator
                .colorScheme(colorScheme)
            )
            Spacer()
        }
    }
}

//MARK: Preview
#Preview {
    CardInfoFooterView(themeConfigurator: RozetkaPayThemeConfigurator(mode: .dark))
}
