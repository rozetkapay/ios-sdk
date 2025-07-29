//
//  LegalTextView.swift
//  
//
//  Created by Ruslan Kasian Dev on 29.08.2024.
//

import SwiftUI

struct LegalTextView: UIViewRepresentable {

    //MARK: - Properties
    @Environment(\.colorScheme) var colorScheme
    let themeConfigurator: RozetkaPayThemeConfigurator

    //MARK: - Init
    public init(themeConfigurator: RozetkaPayThemeConfigurator) {
        self.themeConfigurator = themeConfigurator
    }

    func makeUIView(context: Context) -> WrappingTextView {
        let view = WrappingTextView()
        configure(textView: view.textView)
        return view
    }

    func updateUIView(_ uiView: WrappingTextView, context: Context) {
        configure(textView: uiView.textView)
    }

    private func configure(textView: UITextView) {
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

        textView.font = themeConfigurator.typography.legalTextUI
        textView.textColor = themeConfigurator.colorScheme(colorScheme).placeholder.toUIColor()
        textView.textAlignment = .center
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
    }

    private func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
        guard let input = input else { return nil }
        return Dictionary(
            uniqueKeysWithValues: input.map {
                key, value in (
                    NSAttributedString.Key(rawValue: key), value
                )
            }
        )
    }

    class WrappingTextView: UIView {
        let textView = UITextView()

        override init(frame: CGRect) {
            super.init(frame: frame)

            textView.isScrollEnabled = false
            textView.isEditable = false
            textView.isSelectable = true
            textView.isUserInteractionEnabled = true
            textView.textAlignment = .center
            textView.backgroundColor = .clear

            textView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(textView)

            NSLayoutConstraint.activate([
                textView.topAnchor.constraint(equalTo: topAnchor),
                textView.bottomAnchor.constraint(equalTo: bottomAnchor),
                textView.leadingAnchor.constraint(equalTo: leadingAnchor),
                textView.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override var intrinsicContentSize: CGSize {
            let targetWidth = bounds.width > 0 ? bounds.width : UIScreen.main.bounds.width - 32
            let fittingSize = CGSize(width: targetWidth, height: .greatestFiniteMagnitude)
            return textView.sizeThatFits(fittingSize)
        }
    }

}

//MARK: Preview
#Preview {
    LegalTextView(themeConfigurator: RozetkaPayThemeConfigurator(mode: .dark))
}
