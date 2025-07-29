//
//  FieldRequirement.swift
//  
//
//  Created by Ruslan Kasian Dev on 27.08.2024.
//

import Foundation

public enum FieldRequirement {
    case none
    case optional
    case required
    
    public var isVisible: Bool {
        return self != .none
    }
    
    public var isRequired: Bool {
        return self == .required
    }
}
