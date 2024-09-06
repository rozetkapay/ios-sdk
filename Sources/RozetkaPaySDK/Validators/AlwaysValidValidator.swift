//
//  AlwaysValidValidator.swift
//
//
//  Created by Ruslan Kasian Dev on 27.08.2024.
//

import Foundation


class AlwaysValidValidator: Validator {

    override func validate(value: String?) -> ValidationResult {
        return .valid
    }
}
