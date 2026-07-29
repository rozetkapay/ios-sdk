//
//  ApplePayFormUIState.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 03.07.2026.
//
import Foundation

public typealias ApplePayFormUIStateCompletionHandler = (ApplePayFormUIState) -> Void

/// Non-terminal UI states streamed by `ApplePayFormView` so the host app
/// can drive its own loader and error presentation.
///
/// `.error` carries a localized message describing why the payment attempt
/// failed — the SDK does not render its own error screen in this flow.
public enum ApplePayFormUIState: Equatable {
    case startLoading
    case stopLoading
    case success
    case error(String)
}
