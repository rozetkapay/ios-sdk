//
//  TokenizationViewModel.swift
//
//
//  Created by Ruslan Kasian Dev on 20.08.2024.
//

import SwiftUI

@MainActor
final class TokenizationViewModel: BaseViewModel {
    
    //MARK: - Constants & Defaults
    private enum Constants {
        static let vStackSpacing: CGFloat = 16
    }
    
    //MARK: - Properties
    private let onResultCallback: (TokenizationResultCompletionHandler)?
    private var hasDeliveredResult = false

    /// Last tokenization error shown on the error screen, used to deliver `.failed` when the user taps "Close".
    private var lastError: TokenizationError?
    
    //MARK: - Init
    init(
        parameters: TokenizationParameters,
        provideCardPaymentSystemUseCase: ProvideCardPaymentSystemUseCase? = nil,
        onResultCallback: @escaping TokenizationResultCompletionHandler
    ) {
        self.onResultCallback = onResultCallback
        super.init(
            client: parameters.client,
            viewParameters: parameters.viewParameters,
            themeConfigurator: parameters.themeConfigurator,
            provideCardPaymentSystemUseCase: provideCardPaymentSystemUseCase ?? ProvideCardPaymentSystemUseCase(),
            errorDismissButtonTitle: parameters.errorDismissButtonTitle
        )
        
        setTestData()
    }
}


//MARK: - Methods
extension TokenizationViewModel {
    func getVStackSpacing() -> CGFloat {
        return Constants.vStackSpacing
    }
    
    func startLoading() {
        guard let validModel: ValidationResultModel = self.validateAll() else {
            return
        }
        let model = CardRequestModel(
            cardName: validModel.cardName,
            cardNumber: validModel.cardNumber,
            cardExpMonth: validModel.cardExpMonth,
            cardExpYear: validModel.cardExpYear,
            cardCvv: validModel.cardCvv,
            cardholderName: validModel.cardholderName,
            customerEmail: validModel.customerEmail
        )
        tokenizeCard(key: client.key, model: model)
    }
    
    func retryLoading() {
        startLoading()
    }

    func cancelled() {
        resetState()
        stopLoader()

        deliver(.cancelled)
    }

    /// Delivers a `.failed` result. Triggered when the user taps the "Close" button on the error screen.
    func failed() {
        resetState()
        stopLoader()

        let error = lastError ?? .failed(message: errorMessage, errorDescription: nil)
        deliver(.failed(error: error))
    }

    func handleViewDisappeared() {
        guard !hasDeliveredResult else { return }
        cancelled()
    }

    func resetState() {
        clearError()
    }

    private func deliver(_ result: TokenizationResult) {
        guard !hasDeliveredResult else { return }
        hasDeliveredResult = true
        onResultCallback?(result)
    }
}

//MARK: - Private Methods
private extension TokenizationViewModel {
    func tokenizeCard(key: String, model: CardRequestModel) {
        resetState()
        startLoader()
        
        TokenizationService.tokenizeCard(key: key, model: model) { [weak self] result in
            Task { @MainActor in
                guard let self else { return }
                self.stopLoader()

                switch result {
                case .complete(let success):
                    self.deliver(
                        .complete(tokenizedCard: success)
                    )
                case .failed(let error):
                    switch error {
                    case .cancelled:
                        self.cancelled()
                    case let .failed(message, _):
                        self.lastError = error
                        self.setError(message)
                    }
                case .cancelled:
                    self.cancelled()
                }
            }
        }
    }
}
