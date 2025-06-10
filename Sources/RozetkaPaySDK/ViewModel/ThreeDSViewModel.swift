//
//  ThreeDSViewModel.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 18.04.2025.
//

import SwiftUI
import OSLog

final class ThreeDSViewModel: ObservableObject {
    //MARK: - UI Properties
    @Published var isLoading = false
    @Published var isError = false
    @Published var isRetry = false
    @Published var error: PaymentError?
    
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
        DispatchQueue.main.async {
            guard !self.hasFinished else {
                return
            }
            self.isLoading = false
            self.error = nil
            self.isError = false
            self.isRetry = true
        }
    }
    
    func handleSuccess() {
        DispatchQueue.main.async {
            guard !self.hasFinished else {
                return
            }
            self.isLoading = false
            self.error = nil
            self.isError = false
            self.hasFinished = true
            
            self.onResultCallback(
                .success(
                    externalId: self.request.externalId,
                    paymentId: self.request.paymentId,
                    tokenizedCard: self.request.tokenizedCard,
                    ordersPayments: self.request.ordersPayments
                )
            )
        }
    }
    
    func handleFailure(_ error: Error? = nil,  message: String? = nil) {
        DispatchQueue.main.async {
            guard !self.hasFinished else {
                return
            }
            
            self.isLoading = false
            self.isError = true
            
            let paymentError = PaymentError(
                code: ErrorResponseCode.threeDSRequired.rawValue,
                message: message ?? error?.localizedDescription,
                externalId: self.request.externalId,
                paymentId: self.request.paymentId,
                type: ErrorResponseType.paymentError.rawValue
            )
            self.error = paymentError
        }
    }
    
    func handleCancelled() {
        DispatchQueue.main.async {
            guard !self.hasFinished else {
                return
            }
            self.isLoading = false
            self.isError = false
            
            
            if let error = self.error {
                self.hasFinished = true
                self.onResultCallback(
                    .failed(
                        error: error,
                        tokenizedCard: self.request.tokenizedCard,
                        ordersPayments: self.request.ordersPayments
                    )
                )
            }else {
                self.error = nil
                self.hasFinished = true
                self.onResultCallback(
                    .cancelled(
                        externalId: self.request.externalId,
                        paymentId: self.request.paymentId,
                        tokenizedCard: self.request.tokenizedCard,
                        ordersPayments: self.request.ordersPayments
                    )
                )
            }
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

