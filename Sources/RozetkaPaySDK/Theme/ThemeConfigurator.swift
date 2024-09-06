//
//  ThemeConfigurator.swift
//
//
//  Created by Ruslan Kasian Dev on 20.08.2024.
//

import UIKit
import PassKit

public struct RozetkaPayThemeConfigurator {
    let lightColorScheme: DomainColorScheme
    let darkColorScheme: DomainColorScheme
    let sizes: DomainSizes
    
    public init(
        lightColorScheme: DomainColorScheme = RozetkaPayDomainThemeDefaults.lightColors(),
        darkColorScheme: DomainColorScheme = RozetkaPayDomainThemeDefaults.darkColors(),
        sizes: DomainSizes = RozetkaPayDomainThemeDefaults.sizes()
    ) {
        self.lightColorScheme = lightColorScheme
        self.darkColorScheme = darkColorScheme
        self.sizes = sizes
    }
}

public struct RozetkaPayDomainThemeDefaults {
    public static func lightColors(
        surface: UIColor = UIColor(hex: "#FFFFFF"),
        onSurface: UIColor = UIColor(hex: "#2B2B2B"),
        appBarIcon: UIColor = UIColor(hex: "#9DA2A6"),
        title: UIColor = UIColor(hex: "#2B2B2B"),
        subtitle: UIColor = UIColor(hex: "#414345"),
        error: UIColor = UIColor(hex: "#FF0B0B"),
        primary: UIColor = UIColor(hex: "#00A046"),
        onPrimary: UIColor = UIColor(hex: "#FFFFFF"),
        placeholder: UIColor = UIColor(hex: "#9DA2A6"),
        componentSurface: UIColor = UIColor(hex: "#F6F7F9"),
        componentDivider: UIColor = UIColor(hex: "#DFE2E5"),
        onComponent: UIColor = UIColor(hex: "#2B2B2B"),
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
    
    public  static func darkColors(
        surface: UIColor = UIColor(hex: "#221F1F"),
        onSurface: UIColor = UIColor(hex: "#EEEEEE"),
        appBarIcon: UIColor = UIColor(hex: "#A7A5A5"),
        title: UIColor = UIColor(hex: "#EEEEEE"),
        subtitle: UIColor = UIColor(hex: "#A7A5A5"),
        error: UIColor = UIColor(hex: "#E56464"),
        primary: UIColor = UIColor(hex: "#00A046"),
        onPrimary: UIColor = UIColor(hex: "#FFFFFF"),
        placeholder: UIColor = UIColor(hex: "#9B9EA0"),
        componentSurface: UIColor = UIColor(hex: "#363436"),
        componentDivider: UIColor = UIColor(hex: "#4E4C4C"),
        onComponent: UIColor = UIColor(hex: "#EEEEEE"),
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
    
    public static func sizes(
        sheetCornerRadius: CGFloat = 20,
        componentCornerRadius: CGFloat = 12,
        buttonCornerRadius: CGFloat = 12,
        borderWidth: CGFloat = 1
    ) -> DomainSizes {
        return DomainSizes(
            sheetCornerRadius: sheetCornerRadius,
            componentCornerRadius: componentCornerRadius,
            buttonCornerRadius: buttonCornerRadius,
            borderWidth: borderWidth
        )
    }
}
