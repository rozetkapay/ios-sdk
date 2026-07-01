//
//  ErrorDismissButtonTitle.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 30.06.2026.
//
import Foundation

/// Title shown on the dismiss button of the error screen.
///
/// Lets host apps choose the wording that fits their UX. The button always
/// delivers a `.failed` result regardless of the chosen title — only the
/// label differs.
public enum ErrorDismissButtonTitle {
    case cancel
    case close
    case custom(String)

    var title: String {
        switch self {
        case .custom(let title):
            return title
        case .cancel:
            return Localization.rozetka_pay_common_button_cancel.description
        case .close:
            return Localization.rozetka_pay_common_button_close.description
        }
       
    }
}
