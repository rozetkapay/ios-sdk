//
//  DomainTheme.swift
//  
//
//  Created by Ruslan Kasian Dev on 20.08.2024.
//

struct DomainTheme {
    static var colors: DomainColorScheme {
        return LocalDomainColorScheme
    }

    static var sizes: DomainSizes {
        return LocalDomainSizes
    }

    static var typography: DomainTypography {
        return LocalDomainTypography
    }
}

let LocalDomainColorScheme = RozetkaPayDomainThemeDefaults.lightColors()
let LocalDomainSizes = RozetkaPayDomainThemeDefaults.sizes()
let LocalDomainTypography = DomainTypographyDefaults()

func domainTheme(
    darkTheme: Bool,
    themeConfigurator: RozetkaPayThemeConfigurator = RozetkaPayThemeConfigurator(),
    content: @escaping () -> Void
) {
    let colorScheme = darkTheme ? themeConfigurator.darkColorScheme : themeConfigurator.lightColorScheme
    let sizes = themeConfigurator.sizes

    content()
}
