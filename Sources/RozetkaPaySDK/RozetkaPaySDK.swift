// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import OSLog
import Foundation

public final class RozetkaPaySdk {
    private static var _appContext: UIApplication?
    private static var _isInitialized: Bool = false

    static var appContext: UIApplication {
        guard _isInitialized,
                let context = _appContext
        else {
            fatalError("⚠️ RozetkaPaySdk is not initialized. Call initSdk() first. ⚠️")
        }
        return context
    }

    static var mode: RozetkaPaySdkMode = .production
    static var isLoggingEnabled: Bool = false
    static var validationRules: RozetkaPaySdkValidationRules = RozetkaPaySdkValidationRules()
    static var decimalSeparator: String = "."

    public static func initSdk(
        appContext: UIApplication,
        mode: RozetkaPaySdkMode = .production,
        enableLogging: Bool = false,
        validationRules: RozetkaPaySdkValidationRules = RozetkaPaySdkValidationRules(),
        decimalSeparator: String = "."
    ) {
        self._appContext = appContext
        self.mode = mode
        self._isInitialized = true
        self.isLoggingEnabled = enableLogging
        self.validationRules = validationRules
        self.decimalSeparator = decimalSeparator
        
        checkParameters()
    }

    private static func checkParameters() {
        if isLoggingEnabled {
            Logger.viewCycle.warning(
                "⚠️ WARNING: LOGGING IS ENABLED!\nTHIS SHOULD ONLY BE USED IN A DEVELOPMENT ENVIRONMENT. ⚠️"
            )
        }
        
        if mode != .production {
            Logger.viewCycle.warning(
                "⚠️ WARNING: SDK IS RUNNING IN \(mode.rawValue.uppercased()) MODE!\nTHIS CONFIGURATION SHOULD NOT BE USED IN PRODUCTION. ⚠️"
            )
        }
    }
}
