//
//  CardRequest.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 15.08.2024.
//  Copyright © 2024 RozetkaPay. All rights reserved.
//

import UIKit

public struct CardRequestModel: Encodable {
    public var cardNumber: String
    public var cardExpMonth: Int
    public var cardExpYear: Int
    public var cardCvv: String
    /// Property, that specifies the type of token to expect from the data, should not be configured manually
    public var rich: Bool?
    
    // Additional parameters, that have to be included to construct a proper JSON
    private let platform: String = "iOS"
    private let sdkVersion: String = UIDevice.version
    private let osVersion: String = UIDevice.current.systemVersion
    private var osBuildVersion: String = "os_build_version"
    private let osBuildNumber: String = "os_build_number"
    private let deviceId: String = UIDevice.current.identifierForVendor?.uuidString ?? ""
    private let deviceIp: String? = UIDevice.current.ipAddress()
    private let deviceManufacturer = "device_manufacturer"
    private let deviceBrand: String = "Apple"
    private let deviceModel: String = UIDevice.modelName
    private let deviceTags: String = "device_tags"
    private let deviceScreenRes = UIDevice.current.screenSize()
    private let deviceLocale = Locale.current.languageCode
    private let deviceTimeZone: String? = TimeZone.current.abbreviation()
    private let appName: String = UIDevice.appName
    private let appPackage: String = "app_package"
    
    public init(cardNumber: String, expirationDate: CardExpirationDate, cardCvv: String) {
        self.cardNumber = cardNumber
        self.cardExpMonth = expirationDate.month
        self.cardExpYear = expirationDate.year
        self.cardCvv = cardCvv
    }
}
