//
//  Localization.swift
//
//
//  Created by Ruslan Kasian Dev on 19.08.2024.
//

import Foundation

public enum Localization: String {
    
    case rozetka_pay_common_loading_message
    case rozetka_pay_common_error_message
    case rozetka_pay_common_button_cancel
    case rozetka_pay_common_button_retry
    case rozetka_pay_common_button_done
    
    case rozetka_pay_tokenization_title
    case rozetka_pay_tokenization_save_button
    case rozetka_pay_tokenization_error_common
    
    case rozetka_pay_payment_title
    case rozetka_pay_payment_pay_button
    case rozetka_pay_payment_error_unsupported
    case rozetka_pay_payment_error_apple_pay
    case rozetka_pay_payment_error_common
    case rozetka_pay_payment_label_use_card
    case rozetka_pay_payment_legal_text
    case rozetka_pay_payment_legal_text_part_1
    case rozetka_pay_payment_legal_text_part_2
    
    case rozetka_pay_payment_confirmation_3ds_loading
    
    case rozetka_pay_payment_applepay_label_amount
    case rozetka_pay_payment_applepay_label_tax
    case rozetka_pay_payment_applepay_label_total
    
    
    case rozetka_pay_form_card_info_title
    case rozetka_pay_form_optional_card_name
    case rozetka_pay_form_card_number
    case rozetka_pay_form_cvv
    case rozetka_pay_form_exp_date
    case rozetka_pay_form_cardholder_name
    case rozetka_pay_form_email
    case rozetka_pay_form_save_card
    case rozetka_pay_form_validation_exp_date_invalid
    case rozetka_pay_form_validation_exp_date_expired
    case rozetka_pay_form_validation_card_number_incorrect
    case rozetka_pay_form_validation_card_number_empty
    case rozetka_pay_form_validation_cvv_incorrect
    case rozetka_pay_form_validation_cardholder_name_empty
    case rozetka_pay_form_validation_card_name_empty
    case rozetka_pay_form_validation_field_empty
    case rozetka_pay_form_validation_email_incorrect
    
    
    var description: String {
        return Localization.localizedString(forKey: self.rawValue)
    }
    
    func description(with parameters: [String]) -> String {
        var result = self.description
        
        for index in 0..<parameters.count{
            result = result.replacingOccurrences(of: "%\(index+1)", with: parameters[index])
        }
        
        return result
    }
    
    public static func localizedString(forKey key: String) -> String {
        if let customLocalizedString = Bundle.main.localizedString(forKey: key, value: nil, table: nil) as String?,
           customLocalizedString != key {
            return customLocalizedString
        } else {
            return NSLocalizedString(key, bundle: Bundle.module, comment: "")
        }
    }
    
}
