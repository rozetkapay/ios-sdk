//
//  ThreeDSRequest.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 17.04.2025.
//
import Foundation

struct ThreeDSRequest {
    let acsUrl: String  
    let termUrl: String?
    let orderId: String
    let paymentId: String
}
