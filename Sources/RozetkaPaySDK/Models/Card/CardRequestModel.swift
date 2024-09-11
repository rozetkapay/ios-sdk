//
//  CardRequest.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 15.08.2024.
//  Copyright © 2024 RozetkaPay. All rights reserved.
//

import UIKit

public struct CardRequestModel: Encodable {
    private let cardNumber: String
    private let cardExpMonth: Int
    private let cardExpYear: Int
    private let cardCvv: String
    private let cardholderName: String?

    private let platform: String
    private let sdkVersion: String
    private let osVersion: String
    private let osBuildVersion: String
    private let osBuildNumber: String
    private let deviceId: String
    
    private let deviceIp: String?
    private let deviceManufacturer: String?
    private let deviceBrand: String?
    private let deviceModel: String?
    private let deviceTags: String?
    private let deviceScreenRes: String?
    private let deviceLocale: String?
    private let deviceTimeZone: String?
    private let appName: String?
    private let appPackage: String?
    
    private let customerId: String?
    private let customerEmail: String?
    private let deviceCountry: String?
    private let deviceCity: String?
    
    enum CodingKeys: String, CodingKey {
        case cardNumber = "card_number"
        case cardExpMonth = "card_exp_month"
        case cardExpYear = "card_exp_year"
        case cardCvv = "card_cvv"
        case cardholderName = "card_holder_name"
        case platform
        case sdkVersion = "sdk_version"
        case osVersion = "os_version"
        case osBuildVersion = "os_build_version"
        case osBuildNumber = "os_build_number"
        case deviceId = "device_id"
        case deviceIp = "device_ip"
        case deviceManufacturer = "device_manufacturer"
        case deviceBrand = "device_brand"
        case deviceModel = "device_model"
        case deviceTags = "device_tags"
        case deviceScreenRes = "device_screenRes"
        case deviceLocale = "device_locale"
        case deviceTimeZone = "device_time_zone"
        case appName = "app_name"
        case appPackage = "app_package"
        case customerId = "customer_id"
        case customerEmail = "customer_email"
        case deviceCountry = "device_country"
        case deviceCity = "device_city"
    }
    
    init(
        cardNumber: String,
        cardExpMonth: Int,
        cardExpYear: Int,
        cardCvv: String,
        cardholderName: String? = nil,
        
        platform: String = "iOS",
        sdkVersion: String = UIDevice.version,
        osVersion: String = UIDevice.current.systemVersion,
        osBuildVersion: String = "os_build_version",
        osBuildNumber: String = "os_build_number",
        deviceId: String = UIDevice.current.identifierForVendor?.uuidString ?? "",
        
        deviceIp: String? = UIDevice.current.ipAddress(),
        deviceManufacturer: String? = "device_manufacturer",
        deviceBrand: String? = "Apple",
        deviceModel: String? = UIDevice.modelName,
        deviceTags: String? = "device_tags",
        deviceScreenRes: String? = UIDevice.current.screenSize(),
        deviceLocale: String? = Locale.current.languageCode,
        deviceTimeZone: String? = TimeZone.current.abbreviation(),
        appName: String? = UIDevice.appName,
        appPackage: String? = "app_package",
        customerId: String? = nil,
        customerEmail: String? = nil,
        deviceCountry: String? = nil,
        deviceCity: String? = nil
    ) {
        
        if cardNumber.containsNonDigits {
            self.cardNumber = cardNumber.digitsOnly
        }else {
            self.cardNumber = cardNumber
        }
        self.cardExpMonth = cardExpMonth
        self.cardExpYear = cardExpYear
        self.cardCvv = cardCvv
        self.cardholderName = cardholderName
        self.platform = platform
        self.sdkVersion = sdkVersion
        self.osVersion = osVersion
        self.osBuildVersion = osBuildVersion
        self.osBuildNumber = osBuildNumber
        self.deviceId = deviceId
        self.deviceIp = deviceIp
        self.deviceManufacturer = deviceManufacturer
        self.deviceBrand = deviceBrand
        self.deviceModel = deviceModel
        self.deviceTags = deviceTags
        self.deviceScreenRes = deviceScreenRes
        self.deviceLocale = deviceLocale
        self.deviceTimeZone = deviceTimeZone
        self.appName = appName
        self.appPackage = appPackage
        self.customerId = customerId
        self.customerEmail = customerEmail
        self.deviceCountry = deviceCountry
        self.deviceCity = deviceCity
    }
}
