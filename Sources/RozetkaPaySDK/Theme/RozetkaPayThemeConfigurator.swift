//
//  RozetkaPayThemeConfigurator.swift
//
//
//  Created by Ruslan Kasian Dev on 20.08.2024.
//

import PassKit
import SwiftUI

public struct RozetkaPayThemeConfigurator {
    let lightColorScheme: DomainColorScheme
    let darkColorScheme: DomainColorScheme
    let sizes: DomainSizes
    let typography: DomainTypography
    
    public init(
        lightColorScheme: DomainColorScheme = RozetkaPayDomainThemeDefaults.lightColors(),
        darkColorScheme: DomainColorScheme = RozetkaPayDomainThemeDefaults.darkColors(),
        sizes: DomainSizes = RozetkaPayDomainThemeDefaults.sizes(),
        typography: DomainTypography = RozetkaPayDomainThemeDefaults.typography()
    ) {
        self.lightColorScheme = lightColorScheme
        self.darkColorScheme = darkColorScheme
        self.sizes = sizes
        self.typography = typography
    }
}

extension RozetkaPayThemeConfigurator {
    func colorScheme(_ sheme: ColorScheme = .light) -> DomainColorScheme {
        switch sheme {
        case .dark:
            return self.darkColorScheme
        case .light:
            return self.lightColorScheme
        @unknown default:
            return self.lightColorScheme
        }
    }
}

public struct RozetkaPayDomainThemeDefaults {
    public static func lightColors(
        surface: Color = Color(hex: "#FFFFFF"),
        onSurface: Color = Color(hex: "#2B2B2B"),
        appBarIcon: Color = Color(hex: "#9DA2A6"),
        title: Color = Color(hex: "#2B2B2B"),
        subtitle: Color = Color(hex: "#414345"),
        error: Color = Color(hex: "#FF0B0B"),
        primary: Color = Color(hex: "#00A046"),
        onPrimary: Color = Color(hex: "#FFFFFF"),
        placeholder: Color = Color(hex: "#9DA2A6"),
        componentSurface: Color = Color(hex: "#F6F7F9"),
        componentDivider: Color = Color(hex: "#DFE2E5"),
        onComponent: Color = Color(hex: "#2B2B2B"),
        applePayButtonStyle: PKPaymentButtonStyle = .black
    ) -> DomainColorScheme {
        return DomainColorScheme(
            surface: surface,
            onSurface: onSurface,
            appBarIcon: appBarIcon,
            title: title,
            subtitle: subtitle,
            error: error,
            primary: primary,
            onPrimary: onPrimary,
            placeholder: placeholder,
            componentSurface: componentSurface,
            componentDivider: componentDivider,
            onComponent: onComponent, 
            applePayButtonStyle: applePayButtonStyle
        )
    }
    
    public  static func darkColors(
        surface: Color = Color(hex: "#221F1F"),
        onSurface: Color = Color(hex: "#EEEEEE"),
        appBarIcon: Color = Color(hex: "#A7A5A5"),
        title: Color = Color(hex: "#EEEEEE"),
        subtitle: Color = Color(hex: "#A7A5A5"),
        error: Color = Color(hex: "#E56464"),
        primary: Color = Color(hex: "#00A046"),
        onPrimary: Color = Color(hex: "#FFFFFF"),
        placeholder: Color = Color(hex: "#9B9EA0"),
        componentSurface: Color = Color(hex: "#363436"),
        componentDivider: Color = Color(hex: "#4E4C4C"),
        onComponent: Color = Color(hex: "#EEEEEE"),
        applePayButtonStyle: PKPaymentButtonStyle = .white
    ) -> DomainColorScheme {
        
        return DomainColorScheme(
            surface: surface,
            onSurface: onSurface,
            appBarIcon: appBarIcon,
            title: title,
            subtitle: subtitle,
            error: error,
            primary: primary,
            onPrimary: onPrimary,
            placeholder: placeholder,
            componentSurface: componentSurface,
            componentDivider: componentDivider,
            onComponent: onComponent, 
            applePayButtonStyle: applePayButtonStyle
        )
    }
    
    public static func sizes(
        sheetCornerRadius: CGFloat = 20,
        componentCornerRadius: CGFloat = 16,
        buttonCornerRadius: CGFloat = 16,
        textFieldCornerRadius: CGFloat = 16,
        textFieldFrameHeight: CGFloat = 22,
        borderWidth: CGFloat = 1
    ) -> DomainSizes {
        
        return DomainSizes(
            sheetCornerRadius: sheetCornerRadius,
            componentCornerRadius: componentCornerRadius,
            buttonCornerRadius: buttonCornerRadius,
            textFieldCornerRadius: textFieldCornerRadius,
            textFieldFrameHeight: textFieldFrameHeight,
            borderWidth: borderWidth
        )
    }
    
    public static func typography(
        title: Font = DomainTypographyDefaults.title,
        subtitle: Font = DomainTypographyDefaults.subtitle,
        body: Font = DomainTypographyDefaults.body,
        labelSmall: Font = DomainTypographyDefaults.labelSmall,
        labelLarge: Font = DomainTypographyDefaults.labelLarge,
        input: Font = DomainTypographyDefaults.input,
        legalText: Font = DomainTypographyDefaults.legalText,
        ///
        titleUI: UIFont = DomainTypographyDefaults.titleUI,
        subtitleUI: UIFont = DomainTypographyDefaults.subtitleUI,
        bodyUI: UIFont = DomainTypographyDefaults.bodyUI,
        labelSmallUI: UIFont = DomainTypographyDefaults.labelSmallUI,
        labelLargeUI:UIFont =  DomainTypographyDefaults.labelLargeUI,
        inputUI: UIFont = DomainTypographyDefaults.inputUI,
        legalTextUI: UIFont = DomainTypographyDefaults.legalTextUI
    
    ) -> DomainTypography {
        
        return DomainTypography(
            title: title,
            subtitle: subtitle,
            body: body,
            labelSmall: labelSmall,
            labelLarge: labelLarge,
            input: input,
            legalText: legalText,
            titleUI: titleUI,
            subtitleUI: subtitleUI,
            bodyUI: bodyUI,
            labelSmallUI: labelSmallUI,
            labelLargeUI: labelLargeUI,
            inputUI: inputUI,
            legalTextUI: legalTextUI
        )
    }
    
}
