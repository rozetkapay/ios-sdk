//
//  DomainImages.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 29.05.2025.
//
import UIKit
import SwiftUI

public enum DomainImages: String {
    //system
    case eye
    case eyeSlash
    case xmark
    case xmarkCircle = "xmark.circle.fill"
    case checkmark
    case checkmarkSquareFill
    case square
    //custom
    case payError = "rozetka.pay.error"
    case paySuccess = "rozetka.pay.success"
    case card = "rozetka.pay.ic.card.default"
    case mastercard = "rozetka.pay.ic.mastercard"
    case prostir = "rozetka.pay.ic.prostir"
    case visa = "rozetka.pay.ic.visa"
    case legalMastercard = "rozetka.pay.legal.mastercard"
    case legalPcidss = "rozetka.pay.legal.pcidss"
    case legalVisa = "rozetka.pay.legal.visa"
}

//MARK: - Public Methods and Properties
public extension DomainImages {

    func image(_ appearance: UIUserInterfaceStyle) -> UIImage? {
        return DomainImages.loadUIImage(
            name: self.name(for: appearance),
            appearance: appearance,
            in: .module
        )
    }
    
    func image(_ appearance: UIUserInterfaceStyle) -> Image {
        return DomainImages.loadSwiftUIImage(
            name: self.name(for: appearance),
            appearance: appearance,
            in: .module
        )
    }
}

//MARK: - Public Methods and Properties
public extension DomainImages {
    static func loadSwiftUIImage(
        name: String,
        appearance: UIUserInterfaceStyle,
        in bundle: Bundle
    ) -> Image {
        
        if let image = loadUIImage(
            name: name,
            appearance: appearance,
            in: bundle
        ) {
            return Image(uiImage: image)
        }
        
        return Image(systemName: name)
    }
    
    static func loadUIImage(
        name: String,
        appearance: UIUserInterfaceStyle,
        in bundle: Bundle
    ) -> UIImage? {
        let traitCollection = UITraitCollection(
            userInterfaceStyle: appearance
        )
        
        if let image = UIImage(
            named: name,
            in: bundle,
            compatibleWith: traitCollection
        ) {
            return image
        }
        
        return UIImage(systemName: name, compatibleWith: traitCollection)
    }
}

//MARK: - Private Methods
private extension DomainImages {
    
    var isSystemImage: Bool {
        switch self {
        case .eye, .eyeSlash, .xmark, .xmarkCircle,
                .checkmark, .checkmarkSquareFill, .square:
            return true
        default:
            return false
        }
    }
    
    var name: String {
        return self.camelCaseToDotCase()
    }
    
    func name(for appearance: UIUserInterfaceStyle) -> String {
        if isSystemImage {
            return name
        }
        
        switch appearance {
        case .light:
            return name
        case .dark:
            return name + ".dark"
        @unknown default:
            return name
        }
    }
    
    func camelCaseToDotCase() -> String {
        var result = ""
        for (index, character) in self.rawValue.enumerated() {
            if character.isUppercase {
                if index != 0 {
                    result.append(".")
                }
                result.append(character.lowercased())
            } else {
                result.append(character)
            }
        }
        return result
    }
}
