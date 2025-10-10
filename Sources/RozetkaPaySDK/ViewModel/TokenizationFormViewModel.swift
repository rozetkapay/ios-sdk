//
//  TokenizationFormViewModel.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 11.07.2025.
//
import SwiftUI

final class TokenizationFormViewModel: BaseViewModel {
    
    //MARK: - Properties
    private let onResultCallback: (TokenizationFormResultCompletionHandler)?
    private let stateUICallback: (TokenizationFormUIStateCompletionHandler)?
    
    //MARK: - Init
    init(
        parameters: TokenizationFormParameters,
        provideCardPaymentSystemUseCase: ProvideCardPaymentSystemUseCase? = nil,
        onResultCallback: @escaping TokenizationFormResultCompletionHandler,
        stateUICallback: @escaping TokenizationFormUIStateCompletionHandler
    ) {
        self.onResultCallback = onResultCallback
        self.stateUICallback = stateUICallback
        super.init(
            client: parameters.client,
            viewParameters: parameters.viewParameters,
            themeConfigurator: parameters.themeConfigurator,
            provideCardPaymentSystemUseCase: provideCardPaymentSystemUseCase ?? ProvideCardPaymentSystemUseCase()
        )
        
        setTestData()
    }
}


//MARK: - Methods
extension TokenizationFormViewModel {
    
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
        
        onResultCallback?(
            .cancelled
        )
    }
    
    func resetState() {
        DispatchQueue.main.async {
            self.isError = false
            self.errorMessage = nil
        }
    }
}

//MARK: - Private Methods

private extension TokenizationFormViewModel {
    func tokenizeCard(key: String, model: CardRequestModel) {
        resetState()
        startLoader()
        self.stateUICallback?(
            .startLoading
        )
        
        TokenizationService.tokenizeCard(key: key, model: model) { [weak self] result in
            DispatchQueue.main.async {
                self?.stopLoader()
                self?.stateUICallback?(
                    .stopLoading
                )
                
                switch result {
                case .complete(let success):
                    self?.resetState()
                    self?.onResultCallback?(
                        .complete(tokenizedCard: success)
                    )
                case .failed(let error):
                    switch error {
                    case .cancelled:
                        self?.cancelled()
                    case let .failed(message, _):
                        self?.isError = true
                        self?.errorMessage = message
                        self?.onResultCallback?(
                            .failed(error: error)
                        )
                    }
                case .cancelled:
                    self?.cancelled()
                }
            }
        }
    }
}
