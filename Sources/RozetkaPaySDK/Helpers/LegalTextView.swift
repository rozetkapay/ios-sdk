//
//  LegalTextView.swift
//  
//
//  Created by Ruslan Kasian Dev on 29.08.2024.
//

import SwiftUI

struct LegalTextView: UIViewRepresentable {
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        if let agreementLink = URL(string: RozetkaPayConfig.LEGAL_PUBLIC_CONTRACT_LINK.description),
           let companyNameLink = URL(string: RozetkaPayConfig.LEGAL_COMPANY_DETAILS_LINK.description) {
            
            let agreementLinkString = Localization.rozetka_pay_payment_legal_text_part_1.description.setLink(agreementLink)
            let companyNameLinkString = Localization.rozetka_pay_payment_legal_text_part_2.description.setLink(companyNameLink)
            
            let attributedString = Localization.rozetka_pay_payment_legal_text.description.attributed
            attributedString.replace("%1", attributedString: attributedString, with: agreementLinkString)
            attributedString.replace("%2", attributedString: attributedString, with: companyNameLinkString)
            attributedString.addAttribute(
                NSAttributedString.Key.foregroundColor,
                value: UIColor.systemGray6,
                range: NSRange(location: 0, length: attributedString.length)
            )
            
            let linkAttributes: [String : Any] = [
                NSAttributedString.Key.foregroundColor.rawValue: UIColor.systemGray,
                NSAttributedString.Key.underlineColor.rawValue: UIColor.systemGray2,
                NSAttributedString.Key.underlineStyle.rawValue: NSUnderlineStyle.single.rawValue
            ]
            
            textView.dataDetectorTypes = .link
            textView.linkTextAttributes = convertToOptionalNSAttributedStringKeyDictionary(linkAttributes)
            textView.attributedText = attributedString
        }
        textView.font = .systemFont(ofSize: 10)
        textView.textColor = UIColor.systemGray
        textView.textAlignment = .center
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
        
        func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
            guard let input = input else { return nil }
            return Dictionary(
                uniqueKeysWithValues: input.map {
                    key,
                    value in (
                        NSAttributedString.Key(
                            rawValue: key
                        ),
                        value
                    )
                }
            )
        }
        
        
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {}
}
