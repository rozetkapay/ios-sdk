//
//  RozetkaPaySdkApplePayExtensions.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 03.08.2026.
//
import SwiftUI

//MARK: - Imperative Apple Pay API
public extension RozetkaPaySdk {

    /// Checks whether Apple Pay can be used on this device for the given configuration.
    ///
    /// Hosts that draw their own Apple Pay button (UIKit, React Native) should call this
    /// before showing it — `payByApplePay` fails with
    /// `ErrorResponseCode.applePayUnavailable` when Apple Pay is not usable.
    ///
    /// - Parameter config: The Apple Pay configuration the payment will be made with.
    /// - Returns: `true` if Apple Pay is available and supports the configured networks
    ///   and capabilities; otherwise `false`.
    @MainActor
    static func isApplePayAvailable(config: ApplePayConfig) -> Bool {
        return config.checkApplePayAvailability()
    }

    /// Starts an Apple Pay payment without rendering any SDK form.
    ///
    /// The imperative counterpart of `ApplePayFormView`: the host draws its own button
    /// and its own loader, while the SDK shows the Apple Pay sheet, creates the payment,
    /// presents the 3DS screen if the payment requires confirmation, and polls until the
    /// payment reaches a terminal state.
    ///
    /// `onResultCallback` is called exactly once, after the SDK has torn down its own UI.
    /// Dismissing the Apple Pay sheet without paying delivers `.cancelled`.
    ///
    /// - Parameters:
    ///   - parameters: Apple Pay payment configuration.
    ///   - presentingViewController: Controller to present the Apple Pay / 3DS UI from.
    ///     Defaults to the top-most presented controller of the key window.
    ///   - onResultCallback: Receives the terminal `PaymentResult`.
    @MainActor
    static func payByApplePay(
        parameters: ApplePayFormParameters,
        presentingViewController: UIViewController? = nil,
        onResultCallback: @escaping PaymentResultCompletionHandler
    ) {
        guard let host = presentingViewController ?? ApplePayCheckoutPresenter.topMostViewController() else {
            onResultCallback(
                .failed(error: .noPresentingViewController(externalId: parameters.externalId))
            )
            return
        }

        ApplePayCheckoutPresenter.present(
            parameters: parameters,
            on: host,
            onResultCallback: onResultCallback
        )
    }

    /// Batch counterpart of `payByApplePay(parameters:presentingViewController:onResultCallback:)`:
    /// pays for several orders with a single Apple Pay transaction.
    ///
    /// - Parameters:
    ///   - batchParameters: Batch Apple Pay payment configuration.
    ///   - presentingViewController: Controller to present the Apple Pay / 3DS UI from.
    ///     Defaults to the top-most presented controller of the key window.
    ///   - onResultCallback: Receives the terminal `BatchPaymentResult`.
    @MainActor
    static func payByApplePay(
        batchParameters: BatchApplePayFormParameters,
        presentingViewController: UIViewController? = nil,
        onResultCallback: @escaping BatchPaymentResultCompletionHandler
    ) {
        guard let host = presentingViewController ?? ApplePayCheckoutPresenter.topMostViewController() else {
            onResultCallback(
                .failed(
                    batchExternalId: batchParameters.externalId,
                    error: .noPresentingViewController(externalId: batchParameters.externalId),
                    ordersPayments: nil
                )
            )
            return
        }

        ApplePayCheckoutPresenter.present(
            batchParameters: batchParameters,
            on: host,
            onResultCallback: onResultCallback
        )
    }
}

//MARK: - Errors
private extension PaymentError {

    static func noPresentingViewController(externalId: String) -> PaymentError {
        return PaymentError(
            code: ErrorResponseCode.applePayUnavailable.rawValue,
            message: "Unable to find a view controller to present Apple Pay from.",
            externalId: externalId,
            type: ErrorResponseType.paymentError.rawValue
        )
    }
}
