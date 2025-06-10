//
//  DomainImages.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 29.05.2025.
//
import UIKit
import SwiftUI

public enum DomainImages: String {
    
    case eye
    case eyeSlash
    
    case xmark
    case xmarkCircle = "xmark.circle.fill"
    
    case checkmark
    case checkmarkSquareFill
    case square
    
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
    var name: String {
        return self.camelCaseToDotCase()
    }
    
    func image() -> UIImage? {
        return self.loadUIImage()
    }
    
    func image() -> Image {
        return self.loadSwiftUIImage()
    }
}

//MARK: - Private Methods
private extension DomainImages {
    func loadSwiftUIImage() -> Image {
        
        if UIImage(named: self.name, in: .module, with: nil) != nil {
            return Image(self.name, bundle: .module)
        }
        
        return Image(systemName: self.name)
    }
    
    func loadUIImage() -> UIImage? {
        if let image = UIImage(
            named: self.name,
            in: .module,
            with: nil
        ) {
            return image
        }
        
        return UIImage(systemName: self.name)
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
