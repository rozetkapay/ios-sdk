//
//  InsetTextField.swift
//  
//
//  Created by Ruslan Kasian Dev on 28.08.2024.
//

import UIKit

class InsetTextField: UITextField {
    
    var textInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
    var rightViewInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 15)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let originalRect = super.rightViewRect(forBounds: bounds)
        return originalRect.inset(by: rightViewInsets)
        
    }
}
