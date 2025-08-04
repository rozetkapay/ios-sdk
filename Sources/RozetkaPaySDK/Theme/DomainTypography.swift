//
//  DomainTypography.swift
//
//
//  Created by Ruslan Kasian Dev on 04.09.2024.
//

import SwiftUI
import UIKit

// MARK: - DomainTypography Struct

public struct DomainTypography {
    private let fontFamilyDp: FontFamily
    private let titleTextStyleDp: DomainTextStyle
    private let subtitleTextStyleDp: DomainTextStyle
    private let bodyTextStyleDp: DomainTextStyle
    private let labelSmallTextStyleDp: DomainTextStyle
    private let labelLargeTextStyleDp: DomainTextStyle
    private let inputTextStyleDp: DomainTextStyle
    private let legalTextTextStyleDp: DomainTextStyle
    
    ///public
    public var fontFamily: FontFamily {
        return fontFamilyDp
    }
    public var titleTextStyle: DomainTextStyle {
        return titleTextStyleDp
    }
    public var subtitleTextStyle: DomainTextStyle {
        return subtitleTextStyleDp
    }
    public var bodyTextStyle: DomainTextStyle {
        return bodyTextStyleDp
    }
    public var labelSmallTextStyle: DomainTextStyle {
        return labelSmallTextStyleDp
    }
    public var labelLargeTextStyle: DomainTextStyle {
        return labelLargeTextStyleDp
    }
    public var inputTextStyle: DomainTextStyle {
        return inputTextStyleDp
    }
    public var legalTextTextStyle: DomainTextStyle {
        return legalTextTextStyleDp
    }

    ///font and spacing
    public var title: Font {
        let f: Font = titleTextStyle.toFont(fontFamily)
        return titleTextStyle.toFont(fontFamily)
    }
    
    public var subtitle: Font {
        return subtitleTextStyle.toFont(fontFamily)
    }
    
    public var body: Font {
        return bodyTextStyle.toFont(fontFamily)
    }
    
    public var labelSmall: Font {
        return labelSmallTextStyle.toFont(fontFamily)
    }
    
    public var labelLarge: Font {
        return labelLargeTextStyle.toFont(fontFamily)
    }

    public var inputUI: UIFont {
        return inputTextStyle.toUIFont(fontFamily)
    }
    
    public var legalTextUI: UIFont {
        return legalTextTextStyle.toUIFont(fontFamily)
    }
  
    ///FontFamily
    public enum FontFamily {
        case `default`
        case serif
        case monospace
        case custom(name: String)
    }

    public init(
        fontFamily: FontFamily,
        titleTextStyle: DomainTextStyle,
        subtitleTextStyle: DomainTextStyle,
        bodyTextStyle: DomainTextStyle,
        labelSmallTextStyle: DomainTextStyle,
        labelLargeTextStyle: DomainTextStyle,
        inputTextStyle: DomainTextStyle,
        legalTextTextStyle: DomainTextStyle
    ) {
        self.fontFamilyDp = fontFamily
        self.titleTextStyleDp = titleTextStyle
        self.subtitleTextStyleDp = subtitleTextStyle
        self.bodyTextStyleDp = bodyTextStyle
        self.labelSmallTextStyleDp = labelSmallTextStyle
        self.labelLargeTextStyleDp = labelLargeTextStyle
        self.inputTextStyleDp = inputTextStyle
        self.legalTextTextStyleDp = legalTextTextStyle
    }
}

public struct DomainTextStyle {
    private let fontFamily: DomainTypography.FontFamily?
    private let fontSizeDP: Int
    private let fontWeightDp: FontWeight

    public var fontSize: CGFloat {
        return CGFloat(fontSizeDP)
    }
    
    public var fontWeight: FontWeight {
        return fontWeightDp
    }
    
    public enum FontWeight: String {
        case thin
        case extraLight
        case light
        case normal
        case medium
        case semiBold
        case bold
        case extraBold
        case black
    }

    public init(
        fontFamily: DomainTypography.FontFamily? = nil,
        fontSize: CGFloat,
        fontWeight: FontWeight = .normal
    ) {
        self.fontFamily = fontFamily
        self.fontSizeDP = Int(fontSize)
        self.fontWeightDp = fontWeight
    }
    
    func toFont(_ mainFontFamily: DomainTypography.FontFamily) -> Font {
        var _fontFamily: DomainTypography.FontFamily = fontFamily ?? mainFontFamily
        
        switch _fontFamily {
        case .default:
            return .system(size: fontSize, weight: fontWeight.toSwiftUIFontWeight(), design: .default)
        case .serif:
            return .system(size: fontSize, weight: fontWeight.toSwiftUIFontWeight(), design: .serif)
        case .monospace:
            return .system(size: fontSize, weight: fontWeight.toSwiftUIFontWeight(), design: .monospaced)
        case .custom(let name):
            return .custom(name, size: fontSize)
        }
    }

    func toUIFont(_ mainFontFamily: DomainTypography.FontFamily) -> UIFont {
        
        var _fontFamily: DomainTypography.FontFamily = fontFamily ?? mainFontFamily
        
        switch _fontFamily {
        case .default:
            return UIFont.systemFont(ofSize: fontSize, weight: fontWeight.toUIFontWeight())
        case .monospace:
            return UIFont.monospacedSystemFont(ofSize: fontSize, weight: fontWeight.toUIFontWeight())
        case .serif:
            let systemFont = UIFont.systemFont(ofSize: fontSize, weight: fontWeight.toUIFontWeight())
            let descriptor = systemFont.fontDescriptor.withDesign(.serif) ?? systemFont.fontDescriptor
            return UIFont(descriptor: descriptor, size: fontSize)
            
        case .custom(let name):
            return UIFont(name: name, size: fontSize) ??
            UIFont.systemFont(
                ofSize: fontSize,
                weight: fontWeight.toUIFontWeight()
            )
        }
    }
}

extension DomainTextStyle.FontWeight {
    func toSwiftUIFontWeight() -> Font.Weight {
        switch self {
        case .thin:
            return .thin
        case .extraLight:
            return .ultraLight
        case .light:
            return .light
        case .normal:
            return .regular
        case .medium:
            return .medium
        case .semiBold:
            return .semibold
        case .bold:
            return .bold
        case .extraBold:
            return .heavy
        case .black:
            return .black
        }
    }

    func toUIFontWeight() -> UIFont.Weight {
        switch self {
        case .thin:
            return .thin
        case .extraLight:
            return .ultraLight
        case .light:
            return .light
        case .normal:
            return .regular
        case .medium:
            return .medium
        case .semiBold:
            return .semibold
        case .bold:
            return .bold
        case .extraBold:
            return .heavy
        case .black:
            return .black
        }
    }
}

/// Default implementation of `DomainTypography` providing standard text styles.
public struct DomainTypographyDefaults {
    
    public static let defaultFontFamily: DomainTypography.FontFamily = .default
    
    /// Title text style
    public static func title(
        fontFamily: DomainTypography.FontFamily? = nil,
        fontSize: CGFloat = 22,
        fontWeight: DomainTextStyle.FontWeight = .semiBold
    ) -> DomainTextStyle {
        DomainTextStyle(
            fontFamily: fontFamily,
            fontSize: fontSize,
            fontWeight: fontWeight
        )
    }
    
    
    /// Subtitle text style
    public static func subtitle(
        fontFamily: DomainTypography.FontFamily? = nil,
        fontSize: CGFloat = 16,
        fontWeight: DomainTextStyle.FontWeight = .medium
    ) -> DomainTextStyle {
        DomainTextStyle(
            fontFamily: fontFamily,
            fontSize: fontSize,
            fontWeight: fontWeight
        )
    }
    
    /// Body text style
    public static func body(
        fontFamily: DomainTypography.FontFamily? = nil,
        fontSize: CGFloat = 16,
        fontWeight: DomainTextStyle.FontWeight = .normal
    ) -> DomainTextStyle {
        DomainTextStyle(
            fontFamily: fontFamily,
            fontSize: fontSize,
            fontWeight: fontWeight
        )
    }
    
    /// Small label text style
    public static func labelSmall(
        fontFamily: DomainTypography.FontFamily? = nil,
        fontSize: CGFloat = 14,
        fontWeight: DomainTextStyle.FontWeight = .normal
    ) -> DomainTextStyle {
        DomainTextStyle(
            fontFamily: fontFamily,
            fontSize: fontSize,
            fontWeight: fontWeight
        )
    }
    
    /// Large label text style
    public static func labelLarge(
        fontFamily: DomainTypography.FontFamily? = nil,
        fontSize: CGFloat = 18,
        fontWeight: DomainTextStyle.FontWeight = .semiBold
    ) -> DomainTextStyle {
        DomainTextStyle(
            fontFamily: fontFamily,
            fontSize: fontSize,
            fontWeight: fontWeight
        )
    }
    
    /// Input text style
    public static func input(
        fontFamily: DomainTypography.FontFamily? = nil,
        fontSize: CGFloat = 16,
        fontWeight: DomainTextStyle.FontWeight = .normal
    ) -> DomainTextStyle {
        DomainTextStyle(
            fontFamily: fontFamily,
            fontSize: fontSize,
            fontWeight: fontWeight
        )
    }
   
    /// Legal text style
    public static func legalText(
        fontFamily: DomainTypography.FontFamily? = nil,
        fontSize: CGFloat = 9,
        fontWeight: DomainTextStyle.FontWeight = .normal
    ) -> DomainTextStyle {
        DomainTextStyle(
            fontFamily: fontFamily,
            fontSize: fontSize,
            fontWeight: fontWeight
        )
    }
}
