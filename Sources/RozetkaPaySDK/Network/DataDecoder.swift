//
//  DataDecoder.swift
//  
//
//  Created by Ruslan Kasian Dev on 01.09.2024.
//

import Foundation

final class DataDecoder: JSONDecoder {
    override init() {
        super.init()
        keyDecodingStrategy = .convertFromSnakeCase
    }
}
