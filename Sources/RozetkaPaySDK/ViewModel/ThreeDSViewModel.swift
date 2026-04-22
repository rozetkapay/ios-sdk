//
//  ThreeDSViewModel.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 18.04.2025.
//

import SwiftUI
import OSLog

@MainActor
final class ThreeDSViewModel: ObservableObject {
    //MARK: - UI Properties
    @Published private(set) var isLoading = false
    @Published private(set) var isError = false
    @Published private(set) var isRetry = false
    @Published private(set) var error: PaymentError?
    
    //MARK: - Properties
    let themeConfigurator: RozetkaPayThemeConfigurator
    let request: ThreeDSRequest
    let onResultCallback: ThreeDSCompletionHandler
    private var hasFinished = false
    
    private var isValidUrl: Bool {
        guard let url = URL(string: request.acsUrl) else { return false }
        return url.scheme != nil && url.host != nil
    }
    
    
    //MARK: - Init
    init(
        themeConfigurator: RozetkaPayThemeConfigurator,
        request: ThreeDSRequest,
        onResultCallback: @escaping ThreeDSCompletionHandler
    ) {
        self.themeConfigurator = themeConfigurator
        self.request = request
        self.onResultCallback = onResultCallback
        checkRequestValidity()
    }
    
    //MARK: - Methods
    private func checkRequestValidity() {
        guard isValidUrl else {
            handleFailure(message: "Invalid 3DS URL")
            return
        }
    }
    
    func retry() {
        guard !hasFinished else {
            return
        }
        isLoading = false
        error = nil
        isError = false
        isRetry = true
    }

    func markRetryConsumed() {
        isRetry = false
    }

    func handleSuccess() {
        guard !hasFinished else {
            return
        }
        isLoading = false
        error = nil
        isError = false
        hasFinished = true

        onResultCallback(
            .success(
                externalId: request.externalId,
                paymentId: request.paymentId,
                tokenizedCard: request.tokenizedCard,
                ordersPayments: request.ordersPayments
            )
        )
    }

    /// Surfaces a 3DS error in the UI without finalizing the flow.
    ///
    /// Stores the error and flips `isError` so `ThreeDSView` renders `errorView`.
    /// The flow is finalized only when the user taps the close / cancel button,
    /// which routes through `handleCancelled()` and emits `.failed(error:)`
    /// because `self.error` is set here. This lets the user keep the sheet open
    /// to read the message instead of being kicked out immediately.
    func handleFailure(_ error: Error? = nil,  message: String? = nil) {
        guard !hasFinished else {
            return
        }

        isLoading = false
        isError = true

        let paymentError = PaymentError(
            code: ErrorResponseCode.threeDSRequired.rawValue,
            message: message ?? error?.localizedDescription,
            externalId: request.externalId,
            paymentId: request.paymentId,
            type: ErrorResponseType.paymentError.rawValue
        )
        self.error = paymentError
    }

    func handleCancelled() {
        guard !hasFinished else {
            return
        }
        isLoading = false
        isError = false

        if let error = self.error {
            hasFinished = true
            onResultCallback(
                .failed(
                    error: error,
                    tokenizedCard: request.tokenizedCard,
                    ordersPayments: request.ordersPayments
                )
            )
        } else {
            self.error = nil
            hasFinished = true
            onResultCallback(
                .cancelled(
                    externalId: request.externalId,
                    paymentId: request.paymentId,
                    tokenizedCard: request.tokenizedCard,
                    ordersPayments: request.ordersPayments
                )
            )
        }
    }
    
    func makeURLRequest() -> URLRequest? {
        guard let url = URL(string: request.acsUrl) else {
            handleFailure(message: "Invalid 3DS URL")
            return nil
        }
        let request = URLRequest(url: url)
        return request
    }
}

