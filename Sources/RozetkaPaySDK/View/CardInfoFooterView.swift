//
//  CardInfoFooterView.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 29.05.2025.
//
import SwiftUI

public struct CardInfoFooterView: View {
    public var body: some View {
        HStack {
            Spacer()
            DomainImages.legalVisa.image()
            DomainImages.legalPcidss.image()
            DomainImages.legalMastercard.image()
            Spacer()
        }
    }
}
