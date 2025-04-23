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
        guard !hasFinished else {
            return
        }
        self.isLoading = false
        self.error = nil
        self.isError = false
        self.isRetry = true
    }
    
    func handleSuccess() {
        guard !hasFinished else {
            return
        }
        self.isLoading = false
        self.error = nil
        self.isError = false
        self.hasFinished = true
        
        onResultCallback(
            .success(
                orderId: request.orderId,
                paymentId: request.paymentId
            )
        )
    }
    
    func handleFailure(_ error: Error? = nil,  message: String? = nil) {
        guard !hasFinished else {
            return
        }
        
        self.isLoading = false
        self.isError = true
        
        let paymentError = PaymentError(
            code: ErrorResponseCode.threeDSRequired.rawValue,
            message: message ?? error?.localizedDescription,
            orderId: request.orderId,
            paymentId: request.paymentId,
            type: ErrorResponseType.paymentError.rawValue
        )
        self.error = paymentError
    }
    
    func handleCancelled() {
        guard !hasFinished else {
            return
        }
        self.isLoading = false
        self.isError = false

        
        if let error = error {
            self.hasFinished = true
            onResultCallback(
                .failed(error: error)
            )
        }else {
            self.error = nil
            self.hasFinished = true
            onResultCallback(
                .cancelled(
                    orderId: request.orderId,
                    paymentId: request.paymentId
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

