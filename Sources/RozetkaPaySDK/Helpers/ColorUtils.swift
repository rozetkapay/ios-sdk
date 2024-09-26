//
//  ColorUtils.swift
//
//
//  Created by Ruslan Kasian Dev on 02.09.2024.
//

import UIKit
import SwiftUI

public extension UIColor {
    convenience init(_ color: Color) {
        let uiColor = UIColor(cgColor: color.cgColor ?? UIColor.clear.cgColor)
        self.init(cgColor: uiColor.cgColor)
    }
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    convenience init(rgb: Int) {
        self.init(
            red: CGFloat((rgb >> 16) & 0xFF) / 255.0,
            green: CGFloat((rgb >> 8) & 0xFF) / 255.0,
            blue: CGFloat(rgb & 0xFF) / 255.0,
            alpha: 1.0
        )
    }

    func toInt() -> Int {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        let rgb = (Int(red * 255) << 16) | (Int(green * 255) << 8) | Int(blue * 255)
        return rgb
    }
}

public extension Color {
    
    init(hex: UInt) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0
        )
    }
    
    func toUIColor() -> UIColor {
        let uiColor = UIColor(self)
        return uiColor
    }
    
    func toHex() -> UInt {
        let components = self.cgColor?.components
        let r = components?[0] ?? 0
        let g = components?[1] ?? 0
        let b = components?[2] ?? 0

        return (UInt(r * 255) << 16) | (UInt(g * 255) << 8) | UInt(b * 255)
    }
    
    init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0

        self.init(
            .sRGB,
            red: red,
            green: green,
            blue: blue,
            opacity: Double(alpha)
        )
    }
    
    func toHex(alpha: Bool = false) -> String {
        let components = self.cgColor?.components
        let r = components?[0] ?? 0
        let g = components?[1] ?? 0
        let b = components?[2] ?? 0
        let a = components?.count ?? 0 > 3 ? components?[3] ?? 1 : 1

        if alpha {
            return String(format: "#%02lX%02lX%02lX%02lX",
                          lround(Double(r * 255)),
                          lround(Double(g * 255)),
                          lround(Double(b * 255)),
                          lround(Double(a * 255)))
        } else {
            return String(format: "#%02lX%02lX%02lX",
                          lround(Double(r * 255)),
                          lround(Double(g * 255)),
                          lround(Double(b * 255)))
        }
    }
}
