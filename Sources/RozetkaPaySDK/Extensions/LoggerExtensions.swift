//
//  LoggerExtensions.swift
//
//
//  Created by Ruslan Kasian Dev on 19.08.2024.
//

import OSLog

extension Logger {
    
    /// A variable to enable or disable logging.
    ///
    /// This flag is controlled by `RozetkaPaySdk.isLoggingEnabled`.
    /// When `true`, log messages are output; otherwise, they are ignored.
    static var isLogEnabled: Bool {
        return RozetkaPaySdk.isLoggingEnabled
    }
    
    /// Using the bundle identifier as a unique identifier for logging.
    ///
    /// The `subsystem` helps to identify the source of the log entries.
    /// If the bundle identifier is not available, it defaults to "RozetkaPaySDK".
    private static var subsystem = Bundle.module.bundleIdentifier ?? "RozetkaPaySDK"

    /// Logs related to the view lifecycle, such as views appearing or disappearing.
    ///
    /// Use this logger to track view-related events and transitions.
    static let viewCycle = Logger(subsystem: subsystem, category: "viewcycle")

    /// Logs related to tracking and analytics.
    ///
    /// Use this logger for events that are related to user activity tracking or app analytics.
    static let statistics = Logger(subsystem: subsystem, category: "statistics")
    
    /// Logs related to network operations.
    ///
    /// Use this logger to capture network-related events, such as requests and responses.
    static let network = Logger(subsystem: subsystem, category: "network")
    
    /// Logs related to Apple Pay operations.
    ///
    /// Use this logger to capture events related to Apple Pay transactions, authorizations, and errors.
    static let payByApplePay = Logger(subsystem: subsystem, category: "payByApplePay")
    
    /// Use this logger to capture events related to Tokenized Card, authorizations, and errors.
    static let tokenizedCard = Logger(subsystem: subsystem, category: "tokenizedCard")
    
    /// Use this logger to capture events related to Pay by Card transactions, authorizations, and errors.
    static let payByCard = Logger(subsystem: subsystem, category: "payByCard")

    /// Use this logger to capture events related to Pay by Card transactions, authorizations, and errors.
    static let payServices = Logger(subsystem: subsystem, category: "payServices")
    
    /// Use this logger to capture events related to localized.
    static let localized = Logger(subsystem: subsystem, category: "localized")

    
    /// Logs a warning message.
    ///
    /// - Parameter message: The warning message to log.
    ///
    /// Use this method to log non-critical issues that might need attention.
    func warning(_ message: String) {
        if Logger.isLogEnabled {
            self.log(level: .error, "\(message, privacy: .public)")
        }
    }
    
    /// Logs an informational message.
    ///
    /// - Parameter message: The informational message to log.
    ///
    /// Use this method to log general information that could be useful for understanding the app's behavior.
    func info(_ message: String) {
        if Logger.isLogEnabled {
            self.log(level: .info, "\(message, privacy: .public)")
        }
    }

    /// Logs an error message.
    ///
    /// - Parameter message: The error message to log.
    ///
    /// Use this method to log critical issues that indicate errors in the app's execution.
    func error(_ message: String) {
        if Logger.isLogEnabled {
            self.log(level: .error, "\(message, privacy: .public)")
        }
    }
    
    /// Logs a debug message.
    ///
    /// - Parameter message: The debug message to log.
    ///
    /// Use this method to log detailed information useful for debugging.
    func debug(_ message: String) {
        if Logger.isLogEnabled {
            self.log(level: .debug, "\(message, privacy: .public)")
        }
    }
}

