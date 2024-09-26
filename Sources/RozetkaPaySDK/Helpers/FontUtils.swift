//
//  File.swift
//  
//
//  Created by Ruslan Kasian Dev on 25.09.2024.
//

import SwiftUI
import UIKit

// MARK: - Font Extension
public extension Font {
    /// Returns a font with the specified size.
    ///
    /// - Parameter size: The desired font size.
    /// - Returns: A new `Font` instance with the specified size.
    func size(_ size: CGFloat) -> Font {
        return Self.system(size: size)
    }
}

public extension UIFont {
    func withWeight(_ weight: UIFont.Weight) -> UIFont {
        let descriptor = self.fontDescriptor.addingAttributes([.traits: [UIFontDescriptor.TraitKey.weight: weight]])
        return UIFont(descriptor: descriptor, size: self.pointSize)
    }
}

// Extension to convert SwiftUI Font to UIFont
public extension UIFont {
    convenience init?(swiftUIFont: Font) {
        switch swiftUIFont {
        case .largeTitle:
            self.init(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .largeTitle), size: 0)
        case .title:
            self.init(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title1), size: 0)
        case .title2:
            self.init(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title2), size: 0)
        case .title3:
            self.init(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title3), size: 0)
        case .headline:
            self.init(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .headline), size: 0)
        case .subheadline:
            self.init(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .subheadline), size: 0)
        case .body:
            self.init(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body), size: 0)
        case .callout:
            self.init(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .callout), size: 0)
        case .caption:
            self.init(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .caption1), size: 0)
        case .caption2:
            self.init(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .caption2), size: 0)
        case .footnote:
            self.init(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .footnote), size: 0)
        default:
            return nil
        }
    }
}
