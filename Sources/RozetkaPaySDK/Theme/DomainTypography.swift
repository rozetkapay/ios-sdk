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
    private let titleDp: Font
    private let subtitleDp: Font
    private let bodyDp: Font
    private let labelSmallDp: Font
    private let labelLargeDp: Font
    private let inputDp: Font
    private let legalTextDp: Font
    
    private let titleUIDp: UIFont
    private let subtitleUIDp: UIFont
    private let bodyUIDp: UIFont
    private let labelSmallUIDp: UIFont
    private let labelLargeUIDp: UIFont
    private let inputUIDp: UIFont
    private let legalTextUIDp: UIFont
    
    public var title: Font {
        return titleDp
    }
    
    public  var subtitle: Font {
        return subtitleDp
    }
    
    public var body: Font {
        return  bodyDp
    }
    
    public var labelSmall: Font {
        return labelSmallDp
    }
    
    public var labelLarge: Font {
        return labelLargeDp
    }
    
    public var input: Font {
        return inputDp
    }
    
    public var legalText: Font {
        return legalTextDp
    }
    
    // UIKit fonts
    public var titleUI: UIFont {
       return titleUIDp
    }
    
    public var subtitleUI: UIFont {
        return subtitleUIDp
    }
    
    public var bodyUI: UIFont {
        return bodyUIDp
    }
    
    public var labelSmallUI: UIFont {
        return labelSmallUIDp
    }
    
    public var labelLargeUI: UIFont {
        return labelLargeUIDp
    }
    
    public var inputUI: UIFont {
        return inputUIDp
    }
    
    public var legalTextUI: UIFont {
        return legalTextUIDp
    }
    
    public init(
        ///Font
        title: Font,
        subtitle: Font,
        body: Font,
        labelSmall: Font,
        labelLarge: Font,
        input: Font,
        legalText: Font,
        ///UIFont
        titleUI: UIFont,
        subtitleUI: UIFont,
        bodyUI: UIFont,
        labelSmallUI: UIFont,
        labelLargeUI: UIFont,
        inputUI: UIFont,
        legalTextUI: UIFont
    ) {
        self.titleDp = title
        self.subtitleDp = subtitle
        self.bodyDp = body
        self.labelSmallDp = labelSmall
        self.labelLargeDp = labelLarge
        self.inputDp = input
        self.legalTextDp = legalText
        ///
        self.titleUIDp = titleUI
        self.subtitleUIDp = subtitleUI
        self.bodyUIDp = bodyUI
        self.labelSmallUIDp = labelSmallUI
        self.labelLargeUIDp = labelLargeUI
        self.inputUIDp = inputUI
        self.legalTextUIDp = legalTextUI
    }
}

/// Default implementation of `DomainTypography` providing standard text styles.
public struct DomainTypographyDefaults {
    
    /// Default font family for all text styles in SwiftUI
    private static let defaultFont = Font.system(.body, design: .default)
    
    /// Default font family for all text styles in UIKit
    private static let defaultFontUI = UIFont.systemFont(ofSize: 16, weight: .regular)
    
    /// Title text style
    public static var title: Font {
        DomainTypographyDefaults.defaultFont
            .weight(.semibold)
            .size(22)
    }
    
    public static var titleUI: UIFont {
        DomainTypographyDefaults
            .defaultFontUI
            .withSize(22)
            .withWeight(.semibold)
    }
    
    /// Subtitle text style
    public static var subtitle: Font {
        DomainTypographyDefaults.defaultFont
            .weight(.medium)
            .size(16)
    }
    
    public static var subtitleUI: UIFont {
        DomainTypographyDefaults
            .defaultFontUI
            .withSize(16)
            .withWeight(.semibold)
    }
    
    /// Body text style
    public static var body: Font {
        DomainTypographyDefaults.defaultFont
            .weight(.regular)
            .size(16)
    }
    
    public static var bodyUI: UIFont {
        DomainTypographyDefaults
            .defaultFontUI
            .withSize(16)
            .withWeight(.regular)
    }
    
    /// Small label text style
    public static var labelSmall: Font {
        DomainTypographyDefaults.defaultFont
            .weight(.regular)
            .size(14)
    }
    
    public static var labelSmallUI: UIFont {
        DomainTypographyDefaults
            .defaultFontUI
            .withSize(14)
            .withWeight(.regular)
    }
    
    /// Large label text style
    public static var labelLarge: Font {
        DomainTypographyDefaults.defaultFont
            .weight(.semibold)
            .size(18)
    }
    
    public static var labelLargeUI: UIFont {
        DomainTypographyDefaults
            .defaultFontUI
            .withSize(18)
            .withWeight(.semibold)
    }
    
    /// Input text style
    public static var input: Font {
        DomainTypographyDefaults.defaultFont
            .weight(.regular)
            .size(16)
    }
    
    public static var inputUI: UIFont {
        DomainTypographyDefaults
            .defaultFontUI
            .withSize(16)
            .withWeight(.regular)
    }
    
    /// Legal text style
    public static var legalText: Font {
        DomainTypographyDefaults
            .defaultFont
            .weight(.regular)
            .size(9)
    }
    
    public static var legalTextUI: UIFont {
        DomainTypographyDefaults
            .defaultFontUI
            .withSize(9)
            .withWeight(.regular)
    }
}
