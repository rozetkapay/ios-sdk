//
//  DomainTypography.swift
//
//
//  Created by Ruslan Kasian Dev on 04.09.2024.
//

import SwiftUI

// MARK: - DomainTypography Protocol
/// A protocol that defines the typography styles for the domain.
protocol DomainTypography: Codable {
    var title: Font { get }
    var subtitle: Font { get }
    var body: Font { get }
    var labelSmall: Font { get }
    var labelLarge: Font { get }
    var input: Font { get }
    var legalText: Font { get }
}

// MARK: - DomainTypographyDefaults Struct

/// Default implementation of `DomainTypography` providing standard text styles.
struct DomainTypographyDefaults: DomainTypography {
    
    /// Default font family for all text styles
    private static let defaultFont = Font.system(.body, design: .default)
    
    /// Title text style
    var title: Font {
        DomainTypographyDefaults.defaultFont
            .weight(.semibold)
            .size(22)
    }
    
    /// Subtitle text style
    var subtitle: Font {
        DomainTypographyDefaults.defaultFont
            .weight(.semibold)
            .size(16)
    }
    
    /// Body text style
    var body: Font {
        DomainTypographyDefaults.defaultFont
            .weight(.regular)
            .size(16)
    }
    
    /// Small label text style
    var labelSmall: Font {
        DomainTypographyDefaults.defaultFont
            .weight(.regular)
            .size(14)
    }
    
    /// Large label text style
    var labelLarge: Font {
        DomainTypographyDefaults.defaultFont
            .weight(.semibold)
            .size(18)
    }
    
    /// Input text style
    var input: Font {
        DomainTypographyDefaults.defaultFont
            .weight(.regular)
            .size(16)
    }
    
    /// Legal text style
    var legalText: Font {
        DomainTypographyDefaults.defaultFont
            .weight(.regular)
            .size(9)
    }
}

// MARK: - Font Extension
extension Font {
    /// Returns a font with the specified size.
    ///
    /// - Parameter size: The desired font size.
    /// - Returns: A new `Font` instance with the specified size.
    func size(_ size: CGFloat) -> Font {
        return Self.system(size: size)
    }
}
