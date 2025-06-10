// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import OSLog
import Foundation

/// Entry point for configuring and accessing RozetkaPay SDK.
///
/// This class provides static configuration for the SDK such as environment mode,
/// logging, validation rules, and decimal formatting. It must be initialized
/// at app launch using `initSdk(...)`.
public final class RozetkaPaySdk {
    
    /// Internal application context. Used for Apple Pay, navigation, etc.
    private static var _appContext: UIApplication?
    
    /// Flag to indicate if the SDK has been initialized.
    private static var _isInitialized: Bool = false

    /// Currently active application context.
    ///
    /// - Warning: Will crash if `initSdk(...)` was not called.
    static var appContext: UIApplication {
        guard _isInitialized, let context = _appContext else {
            fatalError("⚠️ RozetkaPaySdk is not initialized. Call initSdk() first. ⚠️")
        }
        return context
    }

    /// Current working environment mode (e.g., `.production`, `.development`).
    static var mode: RozetkaPaySdkMode = .production

    /// Enables or disables internal SDK logging.
    static var isLoggingEnabled: Bool = false

    /// Input validation rules used by the SDK.
    static var validationRules: RozetkaPaySdkValidationRules = RozetkaPaySdkValidationRules()

    /// Decimal separator for formatting monetary values.
    static var decimalSeparator: String = "."

    /// Initializes the RozetkaPay SDK.
    ///
    /// - Parameters:
    ///   - appContext: The application context (usually `UIApplication.shared`).
    ///   - mode: The environment mode to use. Defaults to `.production`.
    ///   - enableLogging: Enable internal SDK logging. Defaults to `false`.
    ///   - validationRules: Custom validation rules. Defaults to built-in.
    ///   - decimalSeparator: Decimal separator used for amount formatting. Defaults to `"."`.
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

    /// Prints warnings if SDK is not in production configuration.
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

