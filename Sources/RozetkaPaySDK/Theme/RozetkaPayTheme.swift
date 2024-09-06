//
//  RozetkaPayTheme.swift
//
//
//  Created by Ruslan Kasian Dev on 04.09.2024.
//

import SwiftUI

//struct RozetkaPayThemeDefaults {
//    static let lightColors: ColorScheme = ColorScheme(
//        primary: Color(red: 0, green: 93/255, blue: 38/255),
//        onPrimary: Color.white,
//        primaryContainer: Color(red: 0, green: 135/255, blue: 58/255),
//        onPrimaryContainer: Color.white,
//        secondary: Color(red: 58/255, green: 104/255, blue: 65/255),
//        onSecondary: Color.white,
//        secondaryContainer: Color(red: 191/255, green: 244/255, blue: 193/255),
//        onSecondaryContainer: Color(red: 38/255, green: 84/255, blue: 46/255),
//        error: Color(red: 1.0, green: 84/255, blue: 171/255),
//        onError: Color(red: 105/255, green: 0, blue: 5/255)
//    ) ?? <#default value#>
//    
//    static let darkColors: ColorScheme = ColorScheme(
//        primary: Color(red: 95/255, green: 223/255, blue: 124/255),
//        onPrimary: Color(red: 0, green: 57/255, blue: 20/255),
//        primaryContainer: Color(red: 0, green: 135/255, blue: 58/255),
//        onPrimaryContainer: Color.white,
//        secondary: Color(red: 160/255, green: 211/255, blue: 163/255),
//        onSecondary: Color(red: 6/255, green: 57/255, blue: 22/255),
//        secondaryContainer: Color(red: 25/255, green: 72/255, blue: 36/255),
//        onSecondaryContainer: Color(red: 173/255, green: 225/255, blue: 175/255),
//        error: Color(red: 1.0, green: 180/255, blue: 171/255),
//        onError: Color(red: 105/255, green: 0, blue: 5/255)
//    )!
//}
//
//func RozetkaPayTheme(
//    darkTheme: Bool = false,
//    themeConfigurator: RozetkaPayThemeConfigurator = RozetkaPayThemeConfigurator(),
//    content: @escaping () -> Void
//) {
//    let colorScheme = darkTheme ? RozetkaPayThemeDefaults.darkColors : RozetkaPayThemeDefaults.lightColors
//
//    content()
//}

//import SwiftUI
//
//// MARK: - RozetkaPayThemeDefaults
//
///// Provides default color schemes, typography, and shapes for RozetkaPay themes.
//struct RozetkaPayThemeDefaults {
//    
//    // MARK: - Light Colors
//
//    /// Color scheme for light theme.
//    static let lightColors = DomainColorScheme(
//        primary: Color(hex: 0xFF005D26),
//        onPrimary: Color(hex: 0xFFFFFFFF),
//        primaryContainer: Color(hex: 0xFF00873A),
//        onPrimaryContainer: Color(hex: 0xFFFFFFFF),
//        secondary: Color(hex: 0xFF3A6841),
//        onSecondary: Color(hex: 0xFFFFFFFF),
//        secondaryContainer: Color(hex: 0xFFBFF4C1),
//        onSecondaryContainer: Color(hex: 0xFF26542E),
//        tertiary: Color(hex: 0xFF0049B3),
//        onTertiary: Color(hex: 0xFFFFFFFF),
//        tertiaryContainer: Color(hex: 0xFF326EE7),
//        onTertiaryContainer: Color(hex: 0xFFFFFFFF),
//        error: Color(hex: 0xFFA5000D),
//        onError: Color(hex: 0xFFFFFFFF),
//        background: Color(hex: 0xFFFFFFFF),
//        onBackground: Color(hex: 0xFF161D16),
//        surface: Color(hex: 0xFFFFFFFF),
//        onSurface: Color(hex: 0xFF1C1B1B)
//    )
//    
//    // MARK: - Dark Colors
//
//    /// Color scheme for dark theme.
//    static let darkColors = DomainColorScheme(
//        primary: Color(hex: 0xFF5FDF7C),
//        onPrimary: Color(hex: 0xFF003914),
//        primaryContainer: Color(hex: 0xFF00873A),
//        onPrimaryContainer: Color(hex: 0xFFFFFFFF),
//        secondary: Color(hex: 0xFFA0D3A3),
//        onSecondary: Color(hex: 0xFF063916),
//        secondaryContainer: Color(hex: 0xFF194824),
//        onSecondaryContainer: Color(hex: 0xFFADE1AF),
//        tertiary: Color(hex: 0xFFB1C5FF),
//        onTertiary: Color(hex: 0xFF002C72),
//        tertiaryContainer: Color(hex: 0xFF326EE7),
//        onTertiaryContainer: Color(hex: 0xFFFFFFFF),
//        error: Color(hex: 0xFFFFB4AB),
//        onError: Color(hex: 0xFF690005),
//        background: Color(hex: 0xFF0E150E),
//        onBackground: Color(hex: 0xFFDDE5D9),
//        surface: Color(hex: 0xFF141313),
//        onSurface: Color(hex: 0xFFE5E2E1)
//    )
//    
//    // MARK: - Typography
//
//    /// Default typography.
//    static func typography() -> Font {
//        Font.system(.body)
//    }
//    
//    // MARK: - Shapes
//
//    /// Default shapes.
//    static func shapes() -> RoundedRectangle {
//        RoundedRectangle(cornerRadius: 8)
//    }
//}
//
//// MARK: - RozetkaPayTheme
//
///// A custom theme for RozetkaPay that adapts to light and dark mode settings.
//struct RozetkaPayTheme: ViewModifier {
//    var darkTheme: Bool
//    var themeConfigurator: RozetkaPayThemeConfigurator
//
//    func body(content: Content) -> some View {
//        let colorScheme = darkTheme ? RozetkaPayThemeDefaults.darkColors : RozetkaPayThemeDefaults.lightColors
//        
//        return content
//            .background(colorScheme.background)
//            .foregroundColor(colorScheme.onBackground)
//            .environment(\.colorScheme, darkTheme ? .dark : .light)
//    }
//}
//
//// MARK: - View Extension
//
//extension View {
//    func rozetaPayTheme(
//        darkTheme: Bool = false,
//        themeConfigurator: RozetkaPayThemeConfigurator = RozetkaPayThemeConfigurator()
//    ) -> some View {
//        self.modifier(RozetkaPayTheme(darkTheme: darkTheme, themeConfigurator: themeConfigurator))
//    }
//}
//
//// MARK: - Example Usage
//
//struct ContentView: View {
//    var body: some View {
//        VStack {
//            Text("Welcome to RozetkaPay")
//                .font(RozetkaPayThemeDefaults.typography())
//        }
//        .rozetaPayTheme(darkTheme: true)
//    }
//}
//
//// MARK: - Domain Color Scheme
//
//struct DomainColorScheme {
//    var primary: Color
//    var onPrimary: Color
//    var primaryContainer: Color
//    var onPrimaryContainer: Color
//    var secondary: Color
//    var onSecondary: Color
//    var secondaryContainer: Color
//    var onSecondaryContainer: Color
//    var tertiary: Color
//    var onTertiary: Color
//    var tertiaryContainer: Color
//    var onTertiaryContainer: Color
//    var error: Color
//    var onError: Color
//    var background: Color
//    var onBackground: Color
//    var surface: Color
//    var onSurface: Color
//}
//
//// MARK: - Helper to Convert Hex Colors
//
//extension Color {
//    init(hex: Int) {
//        self.init(
//            .sRGB,
//            red: Double((hex >> 16) & 0xFF) / 255,
//            green: Double((hex >> 8) & 0xFF) / 255,
//            blue: Double(hex & 0xFF) / 255,
//            opacity: 1.0
//        )
//    }
//}
//
//// MARK: - Theme Configurator
//
//struct RozetkaPayThemeConfigurator {
//    var darkColorScheme: DomainColorScheme = RozetkaPayThemeDefaults.darkColors
//    var lightColorScheme: DomainColorScheme = RozetkaPayThemeDefaults.lightColors
//}
