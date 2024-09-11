//
//  StringUtils.swift
//  
//
//  Created by Ruslan Kasian Dev on 27.08.2024.
//

import UIKit

extension String {
    var isEmptyOrValue: String? {
        if self == "" || self.isNilOrBlank {
            return nil
        }else{
            return self
        }
    }
    
    var isNilOrEmpty: Bool {
        self == "" || self.isNilOrBlank
    }
    
    var isNilOrBlank: Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        self == nil || self == "" || self.isNilOrBlank
    }
    
    var isNilOrEmptyValue: String? {
        if self == nil || self.isNilOrBlank  {
            return nil
        }else{
            return self
        }
    }
    
    var isNilOrBlank: Bool {
        return self?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
    }
}

extension String{
    
    func digit() -> Int64? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        guard let number = formatter.number(from: self) else {return nil}
        return Int64(truncating: number)
    }
    
    func amount() -> Double? {
        let separator = "."
        var string = self
        if "," == separator {
            string = string.replacingOccurrences(of: ".", with: separator)
        }else{
            string = string.replacingOccurrences(of: ",", with: separator)
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = separator
        return formatter.number(from: string.replacingOccurrences(of: " ", with: ""))?.doubleValue
    }
    
    func currencyFormatWithCoins(font: UIFont, fontScale: CGFloat = 0.6) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        guard let dotIndex = self.firstIndex(of: ".")?.utf16Offset(in: self) else {
            return attributedString
        }
        let newFont = UIFontMetrics(forTextStyle: .body).scaledFont(for: font.withSize(font.pointSize * fontScale))
        let range = NSRange(location: dotIndex, length: self.count - dotIndex)
        attributedString.addAttribute(NSAttributedString.Key.font, value: newFont, range: range)
        return attributedString
    }
    
    func showLastSymbols(_ value: Int) -> String{
        var count = 0
        if let index = self.enumerated().reversed().firstIndex(where: { (offset, element) in
            if String(element).rangeOfCharacter(from: CharacterSet.whitespaces) == nil{
                count+=1
            }
            guard count == value else {
                return false
            }
            return true
        }){
            return String(dropFirst(self.count-(index+1)))
        }
        return self
    }
    
    func mask(from start: Int, left end: Int) -> String {
        let from = start
        let to = self.count-end
        let masked = self.enumerated().map{ (offset, element) -> Character in
            guard offset >= from, offset < to, element != " " else {return element}
            return Character("*")
        }
        return String(masked)
    }
    
    var attributed: NSMutableAttributedString {
        return NSMutableAttributedString(string: self)
    }
    
    func setLink(_ link: URL) -> NSMutableAttributedString {
        let attr = [
            NSAttributedString.Key.link: link
            ] as [NSAttributedString.Key : Any]
        return NSMutableAttributedString(string: self, attributes: attr)
    }
    
    func setLink(_ link: URL, with font: UIFont) -> NSMutableAttributedString {
        let newFont = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let attr = [
            NSAttributedString.Key.link: link,
            NSAttributedString.Key.font: newFont,
            ] as [NSAttributedString.Key : Any]
        return NSMutableAttributedString(string: self, attributes: attr)
    }
    
    func setColor(_ color: UIColor) -> NSMutableAttributedString {
        let attr = [
            NSAttributedString.Key.foregroundColor: color
        ]
        return NSMutableAttributedString(string: self, attributes: attr)
    }
    
    func setFont(_ font: UIFont) -> NSMutableAttributedString {
        let newFont = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let attr = [
            NSAttributedString.Key.font: newFont
        ]
        return NSMutableAttributedString(string: self, attributes: attr)
    }
}

extension NSMutableAttributedString {
    func replace(_ subString: String, attributedString: NSMutableAttributedString, with: NSMutableAttributedString) {
        guard let range = attributedString.string.range(of: subString) else {return}
        let nsRange = NSRange(range, in: attributedString.string)
        attributedString.replaceCharacters(in: nsRange, with: with)
    }
}


